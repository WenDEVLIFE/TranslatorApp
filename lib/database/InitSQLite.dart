import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class InitSQLite {
  Future<Database> initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'translations.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE translations(key TEXT PRIMARY KEY, value TEXT)',
        );
        db.execute(
          'CREATE TABLE reverseTranslations(key TEXT PRIMARY KEY, value TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute(
            'CREATE TABLE reverseTranslations(key TEXT PRIMARY KEY, value TEXT)',
          );
        }
      },
      version: 2,
    );
  }

  Future<void> storeTranslationsInSQLite(Map<String, String> translations) async {
    final Database db = await initializeDatabase();
    Batch batch = db.batch();
    translations.forEach((key, value) {
      batch.insert('translations', {'key': key, 'value': value}, conflictAlgorithm: ConflictAlgorithm.replace);
    });
    await batch.commit(noResult: true);

    print('Translations stored in SQLite');
  }

  Future<void> storeReverseTranslationsInSQLite(Map<String, String> reverseTranslations) async {
    final Database db = await initializeDatabase();
    Batch batch = db.batch();
    reverseTranslations.forEach((key, value) {
      batch.insert('reverseTranslations', {'key': key, 'value': value}, conflictAlgorithm: ConflictAlgorithm.replace);
    });
    await batch.commit(noResult: true);

    print('Reverse translations stored in SQLite');
  }

  Future<void> printTranslations() async {
    final Database db = await initializeDatabase();
    final List<Map<String, dynamic>> maps = await db.query('translations');

    maps.forEach((map) {
      print("Translations");
      print('Key: ${map['key']}, Value: ${map['value']}');
    });
  }

  Future<void> printReverseTranslations() async {
    final Database db = await initializeDatabase();
    final List<Map<String, dynamic>> maps = await db.query('reverseTranslations');

    maps.forEach((map) {
      print("Reverse Translations");
      print('Key: ${map['key']}, Value: ${map['value']}');
    });
  }
}