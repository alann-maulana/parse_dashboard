import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

final LocalStorage localStorage = LocalStorage._();

class LocalStorage {
  LocalStorage._();

  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getString(key);
    if (result == null) return null;

    return json.decode(result);
  }

  Future<void> write(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(value));
  }
}
