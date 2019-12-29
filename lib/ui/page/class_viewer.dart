import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';

import 'dashboard_page.dart';

class ClassViewer extends StatefulWidget {
  static const String ROUTE = DashboardPage.ROUTE + '/class';
  final Schema schema;

  ClassViewer(this.schema);

  @override
  _ClassViewerState createState() => _ClassViewerState();
}

class _ClassViewerState extends State<ClassViewer> {
  final encoder = JsonEncoder.withIndent('  ');
  List<dynamic> items;
  List<bool> expanded;

  @override
  void initState() {
    super.initState();

    fetch();
  }

  Future<void> fetch() async {
    final list = await ParseQuery(
      className: widget.schema.className,
    ).findAsync(useMasterKey: true);

    if (mounted) {
      setState(() {
        items = list;
        expanded = list.map((_) => false).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : items.isNotEmpty
              ? SingleChildScrollView(
                  child: ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        expanded[index] = !isExpanded;
                      });
                    },
                    children: items.map<ExpansionPanel>((o) {
                      dynamic body = 'Unknown data';
                      if (o is ParseObject) {
                        Map<String, dynamic> map = o.asMap;
                        map.remove('className');
                        body = encoder.convert(map);
                      }
                      return ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          final onTap = () {
                            setState(() {
                              expanded[items.indexOf(o)] = !isExpanded;
                            });
                          };

                          if (o is ParseSession) {
                            return ListTile(
                              title: Text(o.objectId),
                              subtitle: Text('User#${o.user.objectId}'),
                              trailing: Text(o.authProvider),
                              onTap: onTap,
                            );
                          }

                          if (o is ParseUser) {
                            return ListTile(
                              title: Text(o.username),
                              subtitle: Text(o.email),
                              onTap: onTap,
                            );
                          }

                          if (o is ParseObject) {
                            return ListTile(
                              title: Text(o.objectId),
                              onTap: onTap,
                            );
                          }

                          return ListTile(
                            title: Text('Unknown object'),
                          );
                        },
                        body: ListTile(
                          title: Text(body),
                        ),
                        isExpanded: expanded[items.indexOf(o)],
                      );
                    }).toList(),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.data_usage,
                        size: 96,
                        color: Colors.blueGrey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No data to display',
                        style: Theme.of(context).textTheme.headline.copyWith(
                              color: Colors.blueGrey,
                            ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
