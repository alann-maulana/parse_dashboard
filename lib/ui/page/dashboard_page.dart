import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';
import 'package:parse_dashboard/core/models/parse_credential.dart';

import 'class_viewer.dart';
import 'dashboard_drawer.dart';

class DashboardPage extends StatefulWidget {
  static const String ROUTE = '/dashboard';
  final ParseCredential credential;

  DashboardPage(this.credential);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Schema> schemas;
  Schema selected;

  @override
  void initState() {
    Parse.initialize(widget.credential.configuration);

    super.initState();

    fetch();
  }

  Future<void> fetch() async {
    try {
      final schemas = await parseSchema.fetch();
      if (mounted) {
        setState(() {
          schemas.sort((a, b) => a.className.compareTo(b.className));
          if (this.schemas == null) {
            this.schemas = [];
          } else {
            this.schemas.clear();
          }

          final List<Schema> specials = [];
          final List<Schema> customs = [];
          schemas.forEach((schema) {
            if (schema.className.startsWith('_')) {
              specials.add(schema);
            } else {
              customs.add(schema);
            }
          });

          this.schemas.addAll(specials);
          this.schemas.addAll(customs);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DashboardDrawer(
        schemas: schemas,
        callback: _drawerCallback,
      ),
      appBar: AppBar(
        title: InkWell(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.credential.appName),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down),
            ],
          ),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: selected == null
          ? Center(
              child: Text('Select a class within Drawer'),
            )
          : ClassViewer(selected),
    );
  }

  void _drawerCallback(Schema selected) {
    setState(() {
      this.selected = selected;
    });
  }
}
