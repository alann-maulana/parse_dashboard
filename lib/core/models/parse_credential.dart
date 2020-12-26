import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';
import 'package:parse_dashboard/core/utils/uuid.dart';

class ParseCredential {
  final String _id;
  final IconData icon;
  final String appName;
  final ParseConfiguration configuration;

  ParseCredential({
    @required this.appName,
    @required this.configuration,
    String id,
    IconData icon,
  })  : assert(appName != null),
        assert(configuration != null),
        _id = id ?? uuid.generateV4(),
        icon = icon ?? Icons.storage;

  ParseCredential.fromMap(dynamic map)
      : this(
          id: map['id'],
          appName: map['appName'],
          configuration: _parseConfiguration(map['configuration']),
          icon: _parseIconData(map['icon']),
        );

  static ParseConfiguration _parseConfiguration(dynamic map) {
    if (map == null) {
      return null;
    }

    return ParseConfiguration(
      server: map['server'],
      applicationId: map['applicationId'],
      masterKey: map['masterKey'],
      clientKey: map['clientKey'],
      enableLogging: map['enableLogging'] ?? false,
    );
  }

  static IconData _parseIconData(dynamic map) {
    if (map == null) {
      return null;
    }

    int codePoint;
    final mapCodePoint = map['codePoint'];
    if (mapCodePoint is String) {
      codePoint = int.tryParse(mapCodePoint);
    } else if (mapCodePoint is int) {
      codePoint = mapCodePoint;
    }

    return IconData(
      codePoint,
      fontFamily: map['fontFamily'],
    );
  }

  String get id => _id;

  dynamic get asMap {
    final map = <String, dynamic>{
      "configuration": {
        "server": configuration.uri.toString(),
        "applicationId": configuration.applicationId,
        "masterKey": configuration.masterKey,
        "enableLogging": configuration.enableLogging
      },
      "appName": appName,
      "id": _id,
    };

    if (icon != null) {
      map["icon"] = {
        "codePoint": "${icon.codePoint}",
        "fontFamily": icon.fontFamily,
      };
    }

    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParseCredential &&
          runtimeType == other.runtimeType &&
          _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}
