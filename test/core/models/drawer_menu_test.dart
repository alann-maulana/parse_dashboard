import 'package:flutter_test/flutter_test.dart';
import 'package:parse_dashboard/core/models/drawer_menu.dart';

void main() {
  test('Check constant value if equal', () {
    expect(DrawerMenu.browser.label == 'Browser', isTrue);
    expect(DrawerMenu.info.label == 'Info', isTrue);
    expect(DrawerMenu.serverInfo.label == 'Server Info', isTrue);
    expect(DrawerMenu.serverInfo.parent == DrawerMenu.info, isTrue);
  });

  test('Check created instance value if equal', () {
    const test = DrawerMenu('Test', DrawerMenu.browser, 'value-test');

    expect(test.label == 'Test', isTrue);
    expect(test.parent == DrawerMenu.browser, isTrue);
    expect(test.value == 'value-test', isTrue);
  });

  test('Check if created instance defined constant if equal', () {
    const test = DrawerMenu('Browser');

    expect(test == DrawerMenu.browser, isTrue);
    expect(test.label == DrawerMenu.browser.label, isTrue);
    expect(test.parent == DrawerMenu.browser.parent, isTrue);
    expect(test.value == DrawerMenu.browser.value, isTrue);
    expect(test.hashCode == DrawerMenu.browser.hashCode, isTrue);
  });
}
