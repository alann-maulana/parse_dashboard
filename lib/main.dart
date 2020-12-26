import 'dart:async';

import 'package:flutter/material.dart';

import 'core/api/parse_credential_api.dart';
import 'router.dart' as r;
import 'sentry_client.dart';
import 'ui/theme/theme_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await parseCredentialApi
      .initializeAssetJSON('assets/json/parse-credentials.json');

  // handle error framework
  handleErrorFramework();

  // run Parse Dashboard widget app in zone
  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stackTrace) {
    reportError(error, stackTrace);
  });
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
      initialRoute: r.Router.initialRoute,
      onGenerateRoute: r.Router.onGenerateRoute,
    );
  }
}
