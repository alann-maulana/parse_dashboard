import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';
import 'package:parse_dashboard/ui/widget/parse_config_tile.dart';

class ConfigViewer extends StatefulWidget {
  @override
  _ConfigViewerState createState() => _ConfigViewerState();
}

class _ConfigViewerState extends State<ConfigViewer> {
  final encoder = JsonEncoder.withIndent('  ');
  ParseConfig config;

  @override
  void initState() {
    super.initState();

    fetch();
  }

  Future<void> fetch() async {
    final config = await parseConfig.fetch(useMasterKey: true);

    if (mounted) {
      setState(() {
        this.config = config;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: config == null
          ? loadingWidget
          : config.isNotEmpty
              ? itemFoundWidget
              : itemEmptyWidget,
    );
  }

  Widget get loadingWidget => Center(child: CircularProgressIndicator());

  Widget get itemFoundWidget => RefreshIndicator(
        onRefresh: fetch,
        child: ListView(
          children: ListTile.divideTiles(
                  context: context,
                  tiles: parseConfig.keys.map((key) => ParseConfigTile(key)))
              .toList(),
        ),
      );

  Widget get itemEmptyWidget => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.event_note,
              size: 96,
              color: Colors.blueGrey,
            ),
            SizedBox(height: 16),
            Text(
              'No config to display',
              style: Theme.of(context).textTheme.headline5.copyWith(
                    color: Colors.blueGrey,
                  ),
            ),
          ],
        ),
      );
}
