import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';
import 'package:http/http.dart' as http;

class ServerInfoPage extends StatelessWidget {
  const ServerInfoPage(this.configuration, {Key key}) : super(key: key);

  final encoder = const JsonEncoder.withIndent('  ');
  final ParseConfiguration configuration;

  Future<dynamic> get checkServerVersion async {
    try {
      final result = await http.get(
          Uri.tryParse(configuration.uri.toString() + '/serverInfo'),
          headers: {
            'X-Parse-Application-Id': configuration.applicationId,
            'X-Parse-Master-Key': configuration.masterKey,
          });
      final body = result.body;
      return json.decode(body);
    } catch (e) {
      debugPrint(e);
    }

    return {'error': 'Failed to GET /serverInfo'};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkServerVersion,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Failed to GET /serverInfo'),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Text(encoder.convert(snapshot.data)),
        ));
      },
    );
  }
}
