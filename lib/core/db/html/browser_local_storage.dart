import 'package:parse_dashboard/core/db/base_local_storage.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';

createLocalStorage() => BrowserLocalStorage();

class BrowserLocalStorage extends BaseLocalStorage {
  Database _database;

  @override
  Future<void> initialize() async {
    _database = await localStorageDatabase;
  }

  @override
  Future<String> get databaseBasePath async => '';

  @override
  Future<String> get databasePath async => kDatabaseName;

  @override
  Database get database => _database;

  @override
  DatabaseFactory get databaseFactory => databaseFactoryMemory;
}
