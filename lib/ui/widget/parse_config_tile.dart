import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';

class ParseConfigTile extends StatelessWidget {
  final String parseConfigKey;

  const ParseConfigTile(this.parseConfigKey, {Key key}) : super(key: key);

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
                const SizedBox(width: 4),
                const Icon(
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
      return const Icon(Icons.outlined_flag);
    } else if (value is String) {
      return const Icon(Icons.text_format);
    } else if (value is num) {
      return const Icon(Icons.repeat_one);
    } else if (value is DateTime) {
      return const Icon(Icons.date_range);
    } else if (value is Map) {
      return const Icon(Icons.code);
    } else if (value is List) {
      return const Icon(Icons.list);
    } else if (value is ParseGeoPoint) {
      return const Icon(Icons.map);
    } else if (value is ParseFile) {
      return const Icon(Icons.attach_file);
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
      return const Text('View Json');
    } else if (value is List) {
      return const Text('View Array');
    } else if (value is ParseGeoPoint) {
      return Text('${value.latitude},${value.longitude}');
    } else if (value is ParseFile) {
      return const Text('Open File');
    }

    return const SizedBox.shrink();
  }
}
