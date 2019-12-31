import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';

import '../../core/models/drawer_menu.dart';

typedef DashboardDrawerCallback = void Function(DrawerMenu menu);

class DashboardDrawer extends StatefulWidget {
  final String appName;
  final List<Schema> schemas;
  final DashboardDrawerCallback callback;
  final RefreshCallback onRefresh;

  DashboardDrawer({
    @required this.appName,
    @required this.schemas,
    @required this.callback,
    @required this.onRefresh,
  });

  @override
  _DashboardDrawerState createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
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
                Text(
                  'Parse Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.computer,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Server Info',
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
          )
        ];

        if (widget.schemas == null) {
          children.add(Center(
            child: CircularProgressIndicator(),
          ));
        } else {
          final specialClassItems =
              widget.schemas != null && widget.schemas.isNotEmpty
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

          if (specialClassItems == null) {
            children.add(Center(
              child: Text('No class found'),
            ));
          } else {
            if (specialClassItems != null) {
              children.add(
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: widget.onRefresh,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: ListTile.divideTiles(
                          context: context,
                          tiles: specialClassItems,
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
    if (className == '_Installation') {
      return Icon(Icons.devices_other);
    }
    if (className == '_Product') {
      return Icon(Icons.add_shopping_cart);
    }
    if (className == '_Role') {
      return Icon(Icons.people_outline);
    }

    if (className == '_Session') {
      return Icon(Icons.pie_chart_outlined);
    }

    if (className == '_User') {
      return Icon(Icons.person_outline);
    }

    return null;
  }
}
