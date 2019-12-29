import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:parse_dashboard/core/models/parse_credential.dart';

final ParseCredentialApi parseCredentialApi = ParseCredentialApi._();

class ParseCredentialApi {
  ParseCredentialApi._();

  List<ParseCredential> _credentials;

  List<ParseCredential> get credentials => _credentials;

  bool _parseString(String source) {
    final list = json.decode(source);

    if (list is List) {
      _credentials = list.map((c) => ParseCredential.fromMap(c)).toList();
      return true;
    }

    return false;
  }

  Future<void> initializeAssetJSON(String path) async {
    if (_credentials != null) {
      return;
    }

    final source = await rootBundle.loadString(path);
    if (_parseString(source)) {
      return;
    }

    throw FormatException('invalid json credentials');
  }

  Future<void> initializeURLJSON(String path,
      {Map<String, String> headers}) async {
    if (_credentials != null) {
      return;
    }

    final result = await http.get(path, headers: headers);
    final source = result.body;
    if (_parseString(source)) {
      return;
    }

    throw FormatException('invalid json credentials');
  }
}
