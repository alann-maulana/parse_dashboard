import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';
import 'package:parse_dashboard/core/models/parse_credential.dart';

import 'ui/page/class_viewer.dart';
import 'ui/page/dashboard_page.dart';
import 'ui/page/home_page.dart';

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
      case ClassViewer.ROUTE:
        final schema = settings.arguments as Schema;
        return MaterialPageRoute(
          builder: (_) => ClassViewer(schema),
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
