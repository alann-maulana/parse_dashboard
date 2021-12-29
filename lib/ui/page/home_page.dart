import 'package:flutter/material.dart';
import 'package:parse_dashboard/core/api/parse_credential_api.dart';
import 'package:parse_dashboard/core/models/parse_credential.dart';
import 'package:parse_dashboard/ui/widget/parse_credential_tile.dart';

import 'dashboard_page.dart';
import 'parse_credential_form.dart';

class HomePage extends StatefulWidget {
  static const String route = '/';

  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ParseCredential> localCredentials;

  @override
  void initState() {
    super.initState();

    fetchCredentialsFromLocalStorage();
  }

  Future<void> fetchCredentialsFromLocalStorage() async {
    final credentials = await parseCredentialApi.getFromLocalStorage();

    if (mounted) {
      setState(() {
        localCredentials =
            credentials != null && credentials.isNotEmpty ? credentials : [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    children.add(header('LOCAL STORAGE'));
    children.add(divider);
    if (localCredentials == null) {
      children.add(Container(
        padding: const EdgeInsets.all(16),
        child: const Center(child: CircularProgressIndicator()),
      ));
    } else {
      final localStorageTiles = ListTile.divideTiles(
        context: context,
        tiles: localCredentials.map(
          (credential) => ParseCredentialTile(
            credential,
            onTap: () => Navigator.pushNamed(
              context,
              DashboardPage.route,
              arguments: credential,
            ),
            onEdit: (c) async {
              if (mounted) {
                final index = localCredentials.indexOf(c);
                if (index != -1) {
                  setState(() {
                    localCredentials[index] = c;
                  });
                  parseCredentialApi.setLocalStorage(localCredentials);
                } else {
                  debugPrint('Editted element not found');
                }
              }
            },
            onDelete: () async {
              if (mounted) {
                setState(() {
                  localCredentials.remove(credential);
                });
                await parseCredentialApi.setLocalStorage(localCredentials);
              }
            },
          ),
        ),
      ).toList();
      children.addAll(localStorageTiles);
      children.add(divider);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parse Dashboard'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchCredentialsFromLocalStorage,
        child: ListView(
          children: children,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final addedCredential = await Navigator.pushNamed(
            context,
            ParseCredentialForm.route,
          );

          if (mounted && addedCredential is ParseCredential) {
            setState(() {
              localCredentials.add(addedCredential);
            });
            await parseCredentialApi.setLocalStorage(localCredentials);
          }
        },
        tooltip: 'Add New App',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget get divider => const Divider(height: 0);

  Widget header(String label) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 8),
      child: Text(label),
    );
  }
}
