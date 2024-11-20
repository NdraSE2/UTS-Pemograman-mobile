import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'karyawan.db';
  static const _databaseVersion = 1;

  static const tableKaryawan = 'karyawan';

  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Private constructor
  DatabaseHelper._internal();

  // Getter instance
  static DatabaseHelper get instance => _instance;

  // Factory constructor
  factory DatabaseHelper() {
    return _instance;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableKaryawan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertKaryawan(Map<String, dynamic> karyawan) async {
    final db = await database;
    return await db.insert(tableKaryawan, karyawan);
  }

  Future<int> updateKaryawan(Map<String, dynamic> karyawan) async {
    final db = await database;
    return await db.update(
      tableKaryawan,
      karyawan,
      where: 'id = ?',
      whereArgs: [karyawan['id']],
    );
  }

  Future<int> deleteKaryawan(int id) async {
    final db = await database;
    return await db.delete(
      tableKaryawan,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getKaryawan() async {
    final db = await database;
    return await db.query(tableKaryawan);
  }
}
