import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';

class ParseConfigTile extends StatelessWidget {
  final String parseConfigKey;

  ParseConfigTile(this.parseConfigKey);

  @override
  Widget build(BuildContext context) {
    final masterKeyOnly = parseConfig.masterKeyOnly(parseConfigKey);

    return ListTile(
      leading: leadingWidget,
      title: !masterKeyOnly
          ? Text(parseConfigKey)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(parseConfigKey),
                SizedBox(width: 4),
                Icon(
                  Icons.lock_outline,
                  size: 18,
                ),
              ],
            ),
      trailing: valueWidget,
    );
  }

  Widget get leadingWidget {
    final value = parseConfig.get(parseConfigKey);

    if (value is bool) {
      return Icon(Icons.outlined_flag);
    } else if (value is String) {
      return Icon(Icons.text_format);
    } else if (value is num) {
      return Icon(Icons.repeat_one);
    } else if (value is DateTime) {
      return Icon(Icons.date_range);
    } else if (value is Map) {
      return Icon(Icons.code);
    } else if (value is List) {
      return Icon(Icons.list);
    } else if (value is ParseGeoPoint) {
      return Icon(Icons.map);
    } else if (value is ParseFile) {
      return Icon(Icons.attach_file);
    }

    return null;
  }

  Widget get valueWidget {
    final value = parseConfig.get(parseConfigKey);

    if (value is bool) {
      return Switch.adaptive(
        value: value,
        onChanged: (flag) {},
      );
    } else if (value is String) {
      return Text(value);
    } else if (value is num) {
      return Text(value.toString());
    } else if (value is DateTime) {
      return Text(value.toIso8601String());
    } else if (value is Map) {
      return Text('View Json');
    } else if (value is List) {
      return Text('View Array');
    } else if (value is ParseGeoPoint) {
      return Text('${value.latitude},${value.longitude}');
    } else if (value is ParseFile) {
      return Text('Open File');
    }

    return SizedBox.shrink();
  }
}
