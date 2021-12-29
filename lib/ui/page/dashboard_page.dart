import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';
import 'package:parse_dashboard/core/models/parse_credential.dart';
import 'package:parse_dashboard/ui/page/server_info_page.dart';

import '../../core/models/drawer_menu.dart';
import 'class_viewer.dart';
import 'config_viewer.dart';
import 'dashboard_drawer.dart';

class DashboardPage extends StatefulWidget {
  static const String route = '/dashboard';
  final ParseCredential credential;

  const DashboardPage(this.credential, {Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const int kIndexBrowserItemStart = 2;
  List<ParseSchema> schemas;
  PageController pageController;
  int selected = 0;

  @override
  void initState() {
    super.initState();

    init();
  }

  init() async {
    var configuration = widget.credential.configuration;

    Parse.initialize(configuration);
    pageController = PageController(initialPage: 0);
    await fetch();
  }

  Future<void> fetch() async {
    try {
      final schemas = await ParseSchema.fetchAll();
      if (mounted) {
        setState(() {
          schemas.sort((a, b) => a.className.compareTo(b.className));
          if (this.schemas == null) {
            this.schemas = [];
          } else {
            this.schemas.clear();
          }

          final List<ParseSchema> specials = [];
          final List<ParseSchema> customs = [];
          for (var schema in schemas) {
            if (schema.className.startsWith('_')) {
              specials.add(schema);
            } else {
              customs.add(schema);
            }
          }

          this.schemas.addAll(specials);
          this.schemas.addAll(customs);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DashboardDrawer(
        appName: widget.credential.appName,
        schemas: schemas,
        callback: _drawerCallback,
        onRefresh: fetch,
      ),
      appBar: AppBar(
        title: InkWell(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.credential.appName),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
          onTap: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.white,
            height: 36,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  breadCrumbs,
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontSize: 16,
                      ),
                ),
              ],
            ),
          ),
          preferredSize: const Size.fromHeight(36),
        ),
      ),
      body: PageView.builder(
        itemBuilder: (context, index) {
          if (index == 0) {
            return ServerInfoPage(widget.credential.configuration);
          }

          if (index == 1) {
            return const ConfigViewer();
          }

          return ClassViewer(schemas[index - kIndexBrowserItemStart]);
        },
        controller: pageController,
        itemCount: (schemas?.length ?? 0) + kIndexBrowserItemStart,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }

  String get breadCrumbs {
    if (selected == 0) {
      return 'Info › Server Info';
    }

    if (selected == 1) {
      return 'Global › Config';
    }

    if (schemas != null) {
      return 'Browser › ${schemas[selected - kIndexBrowserItemStart].className}';
    }

    return '';
  }

  void _drawerCallback(DrawerMenu menu) {
    setState(() {
      if (menu.value is ParseSchema) {
        selected = schemas.indexOf(menu.value) + kIndexBrowserItemStart;
      } else {
        if (menu.label == '_Config') {
          selected = 1;
        } else {
          selected = 0;
        }
      }
      pageController.animateToPage(
        selected,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }
}
