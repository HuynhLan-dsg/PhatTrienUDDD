import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Models/favourite_route.dart';

class DatabaseHelper {
  static final DatabaseHelper instance =
      DatabaseHelper._init();

  DatabaseHelper._init();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB(
      'routes.db',
    );

    return _database!;
  }

  Future<Database> _initDB(
    String filePath,
  ) async {
    final dbPath =
        await getDatabasesPath();

    final path = join(
      dbPath,
      filePath,
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(
    Database db,
    int version,
  ) async {
    await db.execute(
      '''
      CREATE TABLE routes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        startAddress TEXT,
        endAddress TEXT,
        distance TEXT,
        duration TEXT
      )
      ''',
    );
  }

  Future<int> insertRoute(
    FavoriteRoute route,
  ) async {
    final db = await instance.database;

    return await db.insert(
      "routes",
      route.toMap(),
    );
  }

  Future<List<FavoriteRoute>>
      getRoutes() async {
    final db = await instance.database;

    final result =
        await db.query("routes");

    return result
        .map(
          (e) =>
              FavoriteRoute.fromMap(
            e,
          ),
        )
        .toList();
  }

  Future<int> deleteRoute(
    int id,
  ) async {
    final db = await instance.database;

    return await db.delete(
      "routes",
      where: "id=?",
      whereArgs: [id],
    );
  }
}