import 'package:flutter/material.dart';

import 'core/api/parse_credential_api.dart';
import 'router.dart';
import 'ui/theme/theme_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await parseCredentialApi
      .initializeAssetJSON('assets/json/parse-credentials.json');

  runApp(MyApp());
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
