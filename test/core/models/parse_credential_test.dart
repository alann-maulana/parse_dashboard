import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parse_dashboard/core/models/parse_credential.dart';

void main() {
  test('Check assert constructor', () {
    try {
      ParseCredential(
        appName: null,
        configuration: null,
      );
    } catch (e) {
      expect(e, isInstanceOf<Error>());
    }

    try {
      ParseCredential(
        appName: 'APP_NAME',
        configuration: null,
      );
    } catch (e) {
      expect(e, isInstanceOf<Error>());
    }
  });

  test('Check instance property value if equal', () {
    final credential = ParseCredential(
      appName: 'TEST_NAME',
      icon: Icons.tag_faces,
      configuration: ParseConfiguration(
        server: 'https://test.server.com/',
        applicationId: 'TEST_APPLICATION_ID',
        clientKey: 'TEST_CLIENT_KEY',
        masterKey: 'TEST_MASTER_KEY',
        localStoragePath: '/path/to/local/storage',
        enableLogging: false,
      ),
    );

    expect(credential.appName == 'TEST_NAME', isTrue);
    expect(credential.icon == Icons.tag_faces, isTrue);
    expect(credential.configuration != null, isTrue);
    expect(credential.configuration.uri.isScheme('https'), isTrue);
    expect(credential.configuration.uri.port == 443, isTrue);
    expect(credential.configuration.uri.origin == 'https://test.server.com',
        isTrue);
    expect(credential.configuration.applicationId == 'TEST_APPLICATION_ID',
        isTrue);
    expect(credential.configuration.clientKey == 'TEST_CLIENT_KEY', isTrue);
    expect(credential.configuration.masterKey == 'TEST_MASTER_KEY', isTrue);
    expect(
        credential.configuration.localStoragePath == '/path/to/local/storage',
        isTrue);
    expect(credential.configuration.enableLogging, isFalse);
  });

  test('Check instance from json property value if equal', () {
    final credential = ParseCredential.fromMap({
      "configuration": {
        "server": "https://test.server.com/",
        "applicationId": "TEST_APPLICATION_ID",
        "masterKey": "TEST_MASTER_KEY",
        "localStoragePath": "/path/to/local/storage",
        "enableLogging": false
      },
      "appName": "TEST_NAME",
      "icon": {"codePoint": "0xe420", "fontFamily": "MaterialIcons"}
    });

    expect(credential.appName == 'TEST_NAME', isTrue);
    expect(credential.icon == Icons.tag_faces, isTrue);
    expect(credential.configuration != null, isTrue);
    expect(credential.configuration.uri.isScheme('https'), isTrue);
    expect(credential.configuration.uri.port == 443, isTrue);
    expect(credential.configuration.uri.origin == 'https://test.server.com',
        isTrue);
    expect(credential.configuration.applicationId == 'TEST_APPLICATION_ID',
        isTrue);
    expect(credential.configuration.masterKey == 'TEST_MASTER_KEY', isTrue);
    expect(
        credential.configuration.localStoragePath == '/path/to/local/storage',
        isTrue);
    expect(credential.configuration.enableLogging, isFalse);
  });

  test('Check instance if equal', () {
    final credential = ParseCredential.fromMap({
      "configuration": {
        "server": "https://test.server.com/",
        "applicationId": "TEST_APPLICATION_ID",
      },
      "appName": "TEST_NAME",
      "icon": {"codePoint": "0xe420", "fontFamily": "MaterialIcons"}
    });

    final credential2 = ParseCredential(
      appName: 'TEST_NAME',
      icon: Icons.tag_faces,
      configuration: ParseConfiguration(
        server: 'https://test.server.com/',
        applicationId: 'TEST_APPLICATION_ID',
      ),
    );

    expect(credential == credential2, isTrue);
    expect(credential.hashCode == credential2.hashCode, isTrue);
  });
}
