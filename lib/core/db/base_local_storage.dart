import 'package:flutter/material.dart';
import 'package:parse_dashboard/core/db/local_storage.dart';
import 'package:sembast/sembast.dart' show Database, StoreRef;

abstract class BaseLocalStorage implements LocalStorage {
  @protected
  final String kDatabaseName = 'Parse-Dashboard-Local-Storage.db';

  @protected
  final StoreRef store = StoreRef.main();

  @override
  Future<Database> get localStorageDatabase async {
    final path = await databasePath;
    return await databaseFactory.openDatabase(path);
  }

  @override
  Future<dynamic> read(String key) async {
    return await store.record(key).get(database);
  }

  @override
  Future<void> write(String key, dynamic value) async {
    await store.record(key).put(database, value);
  }
}
