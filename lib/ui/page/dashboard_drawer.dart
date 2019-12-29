import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';

typedef DashboardDrawerCallback = void Function(Schema schema);

class DashboardDrawer extends StatefulWidget {
  final List<Schema> schemas;
  final DashboardDrawerCallback callback;

  DashboardDrawer({
    @required this.schemas,
    @required this.callback,
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
            child: Text(
              'Parse Dashboard',
              style: Theme.of(context).textTheme.title.copyWith(
                    color: Colors.white,
                  ),
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
                        title: Text(schema.className),
                        onTap: () {
                          widget.callback(schema);
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
              children.addAll(specialClassItems);
            }
          }
        }

        return ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: children,
          ).toList(),
        );
      }),
    );
  }
}
