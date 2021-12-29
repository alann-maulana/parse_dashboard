import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';
import 'package:flutter_parse_storage_shared_preferences/flutter_parse_storage_shared_preferences.dart';

import 'core/api/parse_credential_api.dart';
import 'router.dart' as r;
import 'ui/theme/theme_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await parseCredentialApi
      .initializeAssetJSON('assets/json/parse-credentials.json');

  ParseStorageInterface.instance = ParseStorageSharedPreferences();

  // handle error framework
  // handleErrorFramework();

  // run Parse Dashboard widget app in zone
  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stackTrace) {
    // reportError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

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
