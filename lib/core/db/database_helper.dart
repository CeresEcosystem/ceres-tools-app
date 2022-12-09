import 'package:ceres_locker_app/domain/models/favorite_token.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "favorite_tokens.db";
  static const _databaseVersion = 2;
  static const table = "favorites";
  static const columnId = 'assetId';

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
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE $table (
    $columnId TEXT PRIMARY KEY
  )
  ''');
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
