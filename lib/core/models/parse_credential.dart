import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';

class ParseCredential {
  final IconData icon;
  final String appName;
  final ParseConfiguration configuration;

  ParseCredential({
    @required this.appName,
    @required this.configuration,
    IconData icon,
  })  : assert(appName != null),
        assert(configuration != null),
        icon = icon ?? Icons.storage;

  ParseCredential.fromMap(dynamic map)
      : this(
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
      localStoragePath: map['localStoragePath'],
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParseCredential &&
          runtimeType == other.runtimeType &&
          icon == other.icon &&
          appName == other.appName &&
          configuration.applicationId == other.configuration.applicationId;

  @override
  int get hashCode =>
      icon.hashCode ^ appName.hashCode ^ configuration.applicationId.hashCode;
}
