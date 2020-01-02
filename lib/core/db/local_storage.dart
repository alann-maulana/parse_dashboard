import 'package:sembast/sembast.dart';

import 'stub/local_storage_stub.dart'
    if (dart.library.html) 'html/browser_local_storage.dart'
    if (dart.library.io) 'io/io_local_storage.dart';

final LocalStorage localStorage = LocalStorage();

abstract class LocalStorage {
  factory LocalStorage() => createLocalStorage();

  Future<void> initialize();

  Future<String> get databaseBasePath;

  Future<String> get databasePath;

  Database get database;

  DatabaseFactory get databaseFactory;

  Future<Database> get localStorageDatabase;

  Future<dynamic> read(String key);

  Future<void> write(String key, dynamic value);
}
