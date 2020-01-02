import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';
import 'package:parse_dashboard/core/models/parse_credential.dart';
import 'package:parse_dashboard/ui/page/server_info_page.dart';

import '../../core/models/drawer_menu.dart';
import 'class_viewer.dart';
import 'dashboard_drawer.dart';

class DashboardPage extends StatefulWidget {
  static const String ROUTE = '/dashboard';
  final ParseCredential credential;

  DashboardPage(this.credential);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Schema> schemas;
  PageController pageController;
  int selected = 0;

  @override
  void initState() {
    Parse.initialize(widget.credential.configuration);
    pageController = PageController(initialPage: 0);

    super.initState();

    fetch();
  }

  Future<void> fetch() async {
    try {
      final schemas = await parseSchema.fetch();
      if (mounted) {
        setState(() {
          schemas.sort((a, b) => a.className.compareTo(b.className));
          if (this.schemas == null) {
            this.schemas = [];
          } else {
            this.schemas.clear();
          }

          final List<Schema> specials = [];
          final List<Schema> customs = [];
          schemas.forEach((schema) {
            if (schema.className.startsWith('_')) {
              specials.add(schema);
            } else {
              customs.add(schema);
            }
          });

          this.schemas.addAll(specials);
          this.schemas.addAll(customs);
        });
      }
    } catch (e) {
      print(e);
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
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down),
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
                  selected != 0
                      ? schemas == null
                          ? ''
                          : 'Browser › ${schemas[selected - 1].className}'
                      : 'Info › Server Info',
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontSize: 16,
                      ),
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(36),
        ),
      ),
      body: PageView.builder(
        itemBuilder: (context, index) {
          if (index == 0) {
            return ServerInfoPage(widget.credential.configuration);
          }

          return ClassViewer(schemas[index - 1]);
        },
        controller: pageController,
        itemCount: (schemas?.length ?? 0) + 1,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  void _drawerCallback(DrawerMenu menu) {
    setState(() {
      if (menu.value is Schema) {
        this.selected = schemas.indexOf(menu.value) + 1;
      } else {
        this.selected = 0;
      }
      pageController.animateToPage(
        this.selected,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }
}
