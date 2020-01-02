import 'package:flutter/material.dart';
import 'package:parse_dashboard/core/models/parse_credential.dart';

import 'ui/page/dashboard_page.dart';
import 'ui/page/home_page.dart';
import 'ui/page/parse_credential_form.dart';

class Router {
  static const initialRoute = HomePage.ROUTE;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomePage.ROUTE:
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );
      case DashboardPage.ROUTE:
        final credential = settings.arguments as ParseCredential;
        return MaterialPageRoute(
          builder: (_) => DashboardPage(credential),
        );
      case ParseCredentialForm.ROUTE:
        final ParseCredential credential =
            settings.arguments is ParseCredential ? settings.arguments : null;
        return MaterialPageRoute(
          builder: (_) => ParseCredentialForm(credential: credential),
          fullscreenDialog: credential == null,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Unknown route ${settings.name}'),
            ),
          ),
        );
    }
  }
}
