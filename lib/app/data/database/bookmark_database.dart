// ignore_for_file: prefer_conditional_assignment

import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseManager {
  DatabaseManager._private();
  static DatabaseManager instance = DatabaseManager._private();
  Database? _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initDB();
    }
    return _db!;
  }

  Future initDB() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, "bookmark.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        return await database.execute('''
        CREATE TABLE IF NOT EXISTS bookmark (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          surah TEXT NOT NULL,
          surah_number INTEGER NOT NULL,
          ayat INTEGER NOT NULL,
          juz INTEGER NOT NULL,
          via TEXT NOT NULL,
          short TEXT NOT NULL,
          index_ayat INTEGER NOT NULL,
          last_read INTEGER DEFAULT 0
        )
      ''');
      },
    );
  }

  Future closeDB() async {
    _db = await instance.db;
    _db?.close();
  }
}
