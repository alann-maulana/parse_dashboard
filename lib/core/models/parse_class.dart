import 'package:flutter/material.dart';

class ParseClass {
  const ParseClass(this.name, [this.icon]);

  factory ParseClass.from(String className) {
    return values.firstWhere((c) => c.name == className,
        orElse: () => ParseClass(className));
  }

  final String name;
  final IconData icon;

  static const ParseClass installation = ParseClass(
    '_Installation',
    Icons.devices_other,
  );
  static const ParseClass product = ParseClass(
    '_Product',
    Icons.add_shopping_cart,
  );
  static const ParseClass role = ParseClass(
    '_Role',
    Icons.people_outline,
  );
  static const ParseClass session = ParseClass(
    '_Session',
    Icons.pie_chart_outlined,
  );
  static const ParseClass user = ParseClass(
    '_User',
    Icons.person_outline,
  );

  static const List<ParseClass> values = [
    installation,
    product,
    role,
    session,
    user
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParseClass &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
