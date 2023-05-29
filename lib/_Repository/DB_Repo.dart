import 'package:sqflite/sqflite.dart';
import '../_DataSource/DBHelper.dart';


class DBRepo{
  DBHelper dbHelper = DBHelper();

  Future<List<Map<String, dynamic>>> getRecords() async {
    return await DBHelper.getRecords();
  }

  Future<List<Map<String, dynamic>>> rawQuery(String query) async {
    return await DBHelper.rawQuery(query);
  }

  Future<int> insertRecord(Map<String, dynamic> record) async {
    return await DBHelper.insertRecord(record);
  }
}

