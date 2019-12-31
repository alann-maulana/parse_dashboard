import 'package:flutter/material.dart';
import 'package:flutter_parse/flutter_parse.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parse_dashboard/core/models/parse_credential.dart';
import 'package:parse_dashboard/ui/widget/parse_credential_tile.dart';

main() {
  testWidgets('Tile https populated successfully', (WidgetTester tester) async {
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

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ParseCredentialTile(credential),
      ),
    ));

    expect(find.text('TEST_NAME'), findsOneWidget);
    expect(find.text(credential.configuration.uri.host), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);
  });

  testWidgets('Tile http populated successfully', (WidgetTester tester) async {
    final credential = ParseCredential(
      appName: 'TEST_NAME',
      icon: Icons.tag_faces,
      configuration: ParseConfiguration(
        server: 'http://test.server.com/',
        applicationId: 'TEST_APPLICATION_ID',
        clientKey: 'TEST_CLIENT_KEY',
        masterKey: 'TEST_MASTER_KEY',
        localStoragePath: '/path/to/local/storage',
        enableLogging: false,
      ),
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ParseCredentialTile(credential),
      ),
    ));

    expect(find.text('TEST_NAME'), findsOneWidget);
    expect(find.text(credential.configuration.uri.host), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsNothing);
  });
}
