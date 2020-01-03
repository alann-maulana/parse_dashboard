import 'dart:async';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';
import 'package:platform/platform.dart';
import 'package:sentry/sentry.dart';

import 'core/platform/platform.dart' as p;

const String dsn = 'https://5e147ee4631249e09102ae397a9c599b@sentry.io/1870711';

final SentryClient sentry = SentryClient(dsn: dsn);

Platform defaultPlatform;

setupUserContext() async {
  final platform = defaultPlatform ?? p.TargetPlatform();
  final packageInfo = await PackageInfo.fromPlatform();
  final map = <String, dynamic>{
    'version': packageInfo.version,
    'buildNumber': packageInfo.buildNumber,
    'os': platform.operatingSystem,
  };

  final deviceInfo = DeviceInfoPlugin();
  if (platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    map['osVersion'] = androidInfo.version.release;
    map['manufacturer'] = androidInfo.manufacturer;
    map['model'] = androidInfo.model;
  } else if (platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    map['osVersion'] = iosInfo.systemVersion;
    map['manufacturer'] = 'apple';
    map['model'] = iosInfo.utsname.machine;
  } else {
    map['osVersion'] = platform.operatingSystemVersion;
  }

  sentry.userContext = User(
    extras: map,
  );
}

handleErrorFramework() {
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      // In development mode, simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode, report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
}

Future<void> reportError(dynamic error, dynamic stackTrace) async {
  if (kDebugMode) {
    // Print the exception to the console.
    print(error);
    // Print the full stacktrace in debug mode.
    print(stackTrace);
  } else {
    // Send the Exception and Stacktrace to Sentry in Production mode.
    await sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  }
}
