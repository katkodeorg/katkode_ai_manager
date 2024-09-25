import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class ManagerAIDatabase {
  static const String dbName = 'ai_database_test.db';
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    if (kIsWeb) {
      var factory = databaseFactoryWeb;
      _database = await factory.openDatabase(dbName);

      return _database!;
    } else {
      // get the application documents directory
      final dir = await getApplicationDocumentsDirectory();

      // make sure it exists
      await dir.create(recursive: true);

      // build the database path
      final dbPath = join(dir.path, dbName);
      // var codec = getEncryptSembastCodec(password: '[your_user_password]');

      _database = await databaseFactoryIo.openDatabase(dbPath);

      return _database!;
    }
  }

  static Future<Map> saveMap(String id, Map data) async {
    var store = StoreRef<String, Map>.main();
    return await store.record(id).put(await ManagerAIDatabase.database, data);
  }

  // load all data
  static Future<List<Map>> loadAll() async {
    var store = StoreRef<String, Map>.main();
    var records = await store.find(await ManagerAIDatabase.database);

    return records.map((record) => record.value).toList();
  }

  // load data by id
  static Future<Map?> loadMap(String id) async {
    var store = StoreRef<String, Map>.main();
    return await store.record(id).get(await ManagerAIDatabase.database);
  }

  static Future<void> deleteMap(String id) async {
    var store = StoreRef<String, Map>.main();
    await store.record(id).delete(await ManagerAIDatabase.database);
  }
}
