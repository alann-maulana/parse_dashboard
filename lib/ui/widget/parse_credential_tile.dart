import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';
import 'package:http/http.dart' as http;
import 'package:parse_dashboard/core/models/parse_credential.dart';
import 'package:parse_dashboard/ui/page/parse_credential_form.dart';

class ParseCredentialTile extends StatelessWidget {
  final ParseCredential credential;
  final VoidCallback onTap;
  final ValueChanged<ParseCredential> onEdit;
  final VoidCallback onDelete;

  const ParseCredentialTile(
    this.credential, {
    Key key,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: credential.icon == null
          ? null
          : credential.configuration.uri.isScheme("HTTPS")
              ? Stack(
                  children: <Widget>[
                    CircleAvatar(
                      child: Icon(credential.icon),
                    ),
                    const Positioned(
                      child: Icon(
                        Icons.lock,
                        size: 16,
                        color: Colors.black,
                      ),
                      bottom: 0,
                      right: 0,
                    ),
                  ],
                )
              : CircleAvatar(
                  child: Icon(credential.icon),
                ),
      title: Text(credential.appName),
      subtitle: Text(credential.configuration.uri.host),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ServerVersionWidget(credential.configuration),
          popupMenu(context, credential),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget popupMenu(BuildContext context, ParseCredential credential) =>
      PopupMenuButton<String>(
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.visibility),
              title: Text('View'),
            ),
            value: 'view',
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
            ),
            value: 'edit',
          ),
          const PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
            ),
            value: 'delete',
          ),
        ],
        onSelected: (selected) async {
          if (selected == 'view') {
            onTap();
          } else if (selected == 'edit') {
            final editedCredential = await Navigator.pushNamed(
              context,
              ParseCredentialForm.route,
              arguments: credential,
            );

            if (editedCredential is ParseCredential) {
              onEdit(editedCredential);
            }
          } else if (selected == 'delete') {
            onDelete();
          }
        },
      );
}

class ServerVersionWidget extends StatelessWidget {
  final ParseConfiguration configuration;

  const ServerVersionWidget(this.configuration, {Key key}) : super(key: key);

  Future<String> get checkServerVersion async {
    try {
      final result = await http.get(
          Uri.tryParse(configuration.uri.toString() + '/serverInfo'),
          headers: {
            'X-Parse-Application-Id': configuration.applicationId,
            'X-Parse-Master-Key': configuration.masterKey,
          });
      final body = result.body;
      final map = json.decode(body);
      final parseServerVersion = map['parseServerVersion'];
      return parseServerVersion;
    } catch (_) {
      // ignored exception
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: checkServerVersion,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('');
        }

        if (!snapshot.hasData) {
          return const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(),
          );
        }

        return Text(snapshot.data ?? '');
      },
    );
  }
}
