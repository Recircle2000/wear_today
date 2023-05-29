import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:wear_today/_Model/clothesModel.dart';
import 'dart:io';

class DBHelper{
  static late Database _database;

  static Future<Database> get database async {
    await initDatabase();
    return _database;
  }

  static Future<void> initDatabase() async {
    String databasePath = await path.join(
      await getDatabasesPath(),
      'clothes.db',
    );

    ByteData data = await rootBundle.load("assets/DB/clothes.db");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(databasePath).writeAsBytes(bytes, flush: true);

    _database = await openDatabase(
      databasePath,
      version: 1,
    );
  }

  static Future<List<Map<String, dynamic>>> getRecords() async {
    Database database = await DBHelper.database;
    return await database.query('clothes');
  }

  static Future<List<Map<String, dynamic>>> rawQuery(String query) async {
    Database database = await DBHelper.database;
    return await database.rawQuery(query);
  }

  static Future<int> insertRecord(Map<String, dynamic> record) async {
    Database database = await DBHelper.database;
    return await database.insert('clothes', record);
  }
}

