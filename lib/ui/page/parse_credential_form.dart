import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';
import 'package:parse_dashboard/core/models/parse_credential.dart';
import 'package:parse_dashboard/core/utils/uuid.dart';
import 'package:parse_dashboard/ui/page/home_page.dart';

class ParseCredentialForm extends StatefulWidget {
  const ParseCredentialForm({Key key, this.credential}) : super(key: key);

  static const String route = HomePage.route + '/forn-credential';

  final ParseCredential credential;

  @override
  _ParseCredentialFormState createState() => _ParseCredentialFormState();
}

class _ParseCredentialFormState extends State<ParseCredentialForm> {
  String id;
  TextEditingController appNameController;
  IconData iconData;
  TextEditingController serverController;
  TextEditingController applicationIdController;
  TextEditingController masterKeyController;

  @override
  void initState() {
    id = widget.credential?.id ?? uuid.generateV4();
    appNameController = TextEditingController(text: widget.credential?.appName);
    iconData = widget.credential?.icon;
    serverController = TextEditingController(
        text: widget.credential?.configuration?.uri?.toString());
    applicationIdController = TextEditingController(
        text: widget.credential?.configuration?.applicationId);
    masterKeyController = TextEditingController(
        text: widget.credential?.configuration?.masterKey);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.credential != null
              ? 'Edit ${widget.credential.appName}'
              : 'Add Credential',
        ),
      ),
      body: ListView(
        children: <Widget>[
          header('', top: 0),
          textAppName,
          header('PARSE SERVER'),
          textServer,
          textAppId,
          textMasterKey,
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
          left: 16,
          top: 8,
          right: 16,
          bottom: 8,
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                (states) => Colors.orange,
              ),
              foregroundColor: MaterialStateProperty.resolveWith(
                (states) => Colors.white,
              ),
            ),
            icon: const Icon(Icons.save_alt),
            label: const Text('SAVE CREDENTIAL'),
            onPressed: () {
              final appName = appNameController.text;
              final server = serverController.text;
              final appId = applicationIdController.text;
              final masterKey = masterKeyController.text;

              Navigator.pop(
                context,
                ParseCredential(
                  id: id,
                  appName: appName,
                  icon: Icons.apps,
                  configuration: ParseConfiguration(
                    server: server,
                    applicationId: appId,
                    masterKey: masterKey,
                    enableLogging: false,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget header(String label, {double top = 32}) {
    return Container(
      padding: EdgeInsets.only(left: 16, top: top, right: 16, bottom: 8),
      child: Text(label),
    );
  }

  Widget get textAppName => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: appNameController,
          maxLines: null,
          toolbarOptions: const ToolbarOptions(
            copy: true,
            cut: true,
            paste: true,
            selectAll: true,
          ),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.apps),
            labelText: 'Application Name',
          ),
        ),
      );

  Widget get textServer => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: serverController,
          maxLines: null,
          keyboardType: TextInputType.url,
          toolbarOptions: const ToolbarOptions(
            copy: true,
            cut: true,
            paste: true,
            selectAll: true,
          ),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.computer),
            labelText: 'Server URL',
          ),
        ),
      );

  Widget get textAppId => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: applicationIdController,
          maxLines: null,
          toolbarOptions: const ToolbarOptions(
            copy: true,
            cut: true,
            paste: true,
            selectAll: true,
          ),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.perm_identity),
            labelText: 'Application ID',
          ),
        ),
      );

  Widget get textMasterKey => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: masterKeyController,
          maxLines: null,
          toolbarOptions: const ToolbarOptions(
            copy: true,
            cut: true,
            paste: true,
            selectAll: true,
          ),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.lock_outline),
            labelText: 'Master Key',
          ),
        ),
      );
}
