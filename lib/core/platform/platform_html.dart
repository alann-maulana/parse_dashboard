// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:platform/platform.dart';

class TargetPlatform extends Platform {
  @override
  Map<String, String> get environment => {};

  @override
  String get executable => '';

  @override
  List<String> get executableArguments => [];

  @override
  String get localHostname => html.window.navigator.appName;

  @override
  String get localeName => '';

  @override
  int get numberOfProcessors => 0;

  @override
  String get operatingSystem => html.window.navigator.platform;

  @override
  String get operatingSystemVersion => '';

  @override
  String get packageConfig => '';

  @override
  String get pathSeparator => '/';

  @override
  String get resolvedExecutable => '';

  @override
  Uri get script => Uri();

  @override
  bool get stdinSupportsAnsi => false;

  @override
  bool get stdoutSupportsAnsi => false;

  @override
  String get version => html.window.navigator.appVersion;
}
