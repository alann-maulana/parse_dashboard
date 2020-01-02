import 'package:parse_dashboard/core/db/base_local_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform/platform.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

createLocalStorage() => IOLocalStorage();

class IOLocalStorage extends BaseLocalStorage {
  static Platform defaultPlatform;
  Database _database;

  @override
  Future<void> initialize() async {
    _database = await localStorageDatabase;
  }

  @override
  Future<String> get databaseBasePath async {
    final platform = defaultPlatform ?? LocalPlatform();

    if (platform.isAndroid || platform.isIOS) {
      final document = await getApplicationDocumentsDirectory();
      return document.path;
    }

    return '';
  }

  @override
  Future<String> get databasePath async {
    final String documentPath = await databaseBasePath;
    return documentPath.isEmpty
        ? kDatabaseName
        : documentPath + '/' + kDatabaseName;
  }

  @override
  Database get database => _database;

  @override
  DatabaseFactory get databaseFactory => databaseFactoryIo;
}
