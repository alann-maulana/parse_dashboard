import 'dart:async';

import 'package:flutter/material.dart';

import 'core/api/parse_credential_api.dart';
import 'core/db/local_storage.dart';
import 'router.dart';
import 'sentry_client.dart';
import 'ui/theme/theme_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await localStorage.initialize();
  await parseCredentialApi
      .initializeAssetJSON('assets/json/parse-credentials.json');

  // handle error framework
  handleErrorFramework();

  // run TingRoom widget app in zone
  runZoned<Future<void>>(() async {
    runApp(MyApp());
  }, onError: reportError);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parse Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: ThemeColors.blue,
      ),
      initialRoute: Router.initialRoute,
      onGenerateRoute: Router.onGenerateRoute,
    );
  }
}
