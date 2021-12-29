import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';
import 'package:parse_dashboard/core/models/parse_class.dart';

import '../../core/models/drawer_menu.dart';

typedef DashboardDrawerCallback = void Function(DrawerMenu menu);

class DashboardDrawer extends StatefulWidget {
  final String appName;
  final List<ParseSchema> schemas;
  final DashboardDrawerCallback callback;
  final RefreshCallback onRefresh;

  const DashboardDrawer({
    Key key,
    @required this.appName,
    @required this.schemas,
    @required this.callback,
    @required this.onRefresh,
  }) : super(key: key);

  @override
  _DashboardDrawerState createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  bool showDatabaseBrowserItem = true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Builder(builder: (context) {
        final children = <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Parse Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.appName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.computer,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'SERVER INFO',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    widget.callback(
                      DrawerMenu.serverInfo,
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          Material(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.tune),
              title: const Text('GLOBAL CONFIG'),
              onTap: () {
                widget.callback(
                  const DrawerMenu(
                    '_Config',
                    DrawerMenu.config,
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ),
          const Divider(height: 0),
          Material(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.event_note),
              title: const Text('DATABASE BROWSER'),
              trailing: Icon(
                showDatabaseBrowserItem
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
              ),
              onTap: () {
                setState(() {
                  showDatabaseBrowserItem = !showDatabaseBrowserItem;
                });
              },
            ),
          ),
          const Divider(height: 0),
        ];

        if (widget.schemas == null) {
          children.add(const Center(
            child: CircularProgressIndicator(),
          ));
        } else {
          final classItems = widget.schemas != null && widget.schemas.isNotEmpty
              ? widget.schemas.map((schema) {
                  return ListTile(
                    leading: leading(schema.className),
                    title: Text(schema.className),
                    onTap: () {
                      widget.callback(
                        DrawerMenu(
                          schema.className,
                          DrawerMenu.browser,
                          schema,
                        ),
                      );
                      Navigator.pop(context);
                    },
                  );
                }).toList()
              : null;

          if (classItems == null) {
            children.add(const Center(
              child: Text('No class found'),
            ));
          } else {
            if (classItems != null && showDatabaseBrowserItem) {
              children.add(
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: widget.onRefresh,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: ListTile.divideTiles(
                          context: context,
                          tiles: classItems,
                        ).toList(),
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        }

        return Column(
          children: children,
        );
      }),
    );
  }

  Widget leading(String className) {
    final parseClass = ParseClass.from(className);
    if (parseClass.icon != null) {
      return Icon(parseClass.icon);
    }

    return null;
  }
}
