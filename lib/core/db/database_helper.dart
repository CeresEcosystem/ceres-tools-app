import 'package:ceres_locker_app/domain/models/favorite_token.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "favorite_tokens.db";
  static const _databaseVersion = 3;
  static const table = "favorites";
  static const columnId = 'assetId';

  final String _databaseInit = '''
  CREATE TABLE $table (
    $columnId TEXT PRIMARY KEY
  )
  ''';

  final String _databaseMigration = '''
  DROP TABLE IF EXISTS $table
  ''';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(_databaseInit);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute(_databaseMigration);
    await db.execute(_databaseInit);
  }

  Future<int> insert(FavoriteToken token) async {
    Database db = await instance.database;
    var res = await db.insert(table, token.toMap());
    return res;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    var res = await db.query(table);
    return res;
  }

  Future<int> delete(String assetId) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [assetId]);
  }
}
