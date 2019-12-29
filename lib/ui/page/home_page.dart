import 'package:flutter/material.dart';
import 'package:parse_dashboard/core/api/parse_credential_api.dart';
import 'package:parse_dashboard/ui/widget/parse_credential_tile.dart';

import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  static const String ROUTE = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parse Dashboard'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: parseCredentialApi.credentials.map(
            (credential) => ParseCredentialTile(
              credential,
              onTap: () => Navigator.pushNamed(
                context,
                DashboardPage.ROUTE,
                arguments: credential,
              ),
            ),
          ),
        ).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add New App',
        child: Icon(Icons.add),
      ),
    );
  }
}
