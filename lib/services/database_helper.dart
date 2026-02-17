import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/restaurant.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  static const String _tableName = 'favorites';

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'restaurant_app.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        pictureId TEXT NOT NULL,
        city TEXT NOT NULL,
        rating REAL NOT NULL
      )
    ''');
  }

  Future<void> insertFavorite(Restaurant restaurant) async {
    final db = await database;
    await db.insert(_tableName, {
      'id': restaurant.id,
      'name': restaurant.name,
      'description': restaurant.description,
      'pictureId': restaurant.pictureId,
      'city': restaurant.city,
      'rating': restaurant.rating,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return maps.map((map) => Restaurant.fromJson(map)).toList();
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final result = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }
}
