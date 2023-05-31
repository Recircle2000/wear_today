import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database == null) {
      await initDatabase();
    }
    return _database!;
  }

  static Future<void> initDatabase() async {
    if (_database != null) {
      return; // 이미 초기화된 경우 중복 호출 방지
    }
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String databasePath = path.join(documentsDirectory.path, 'clothes.db');

    bool dbExists = await File(databasePath).exists();
    //최초 설치 시 asset에 있던 DB파일을 앱 내부 디렉터리로 복사. 이미 있는경우 복사 안함.
    if (!dbExists) {
      ByteData data = await rootBundle.load("assets/DB/clothes.db");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(databasePath).writeAsBytes(bytes, flush: true);
    }

    _database = await openDatabase(
      //데이터베이스 버전 관리
      databasePath,
      version: 1,
    );
  }

  static Future<List<Map<String, dynamic>>> getRecords() async {
    Database database = await DBHelper.database;
    return await database.query('clothes');
    //clothes 테이블에 있는 모든 데이터를 리스트 맵 형식으로 반환
  }

  static Future<List<Map<String, dynamic>>> rawQuery(String query) async {
    Database database = await DBHelper.database;
    return await database.rawQuery(query);
  }

  static Future<int> insertRecord(Map<String, dynamic> record) async {
    Database database = await DBHelper.database;
    return await database.insert('clothes', record);
  }

  static Future<int> deleteRecord(String imagePath) async {
    Database database = await DBHelper.database;
    return await database.delete('clothes', where: 'imagePath = ?', whereArgs: [imagePath]);
  }
}

