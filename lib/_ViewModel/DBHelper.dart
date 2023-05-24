import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wear_today/_Model/clothesModel.dart';

final String TableName = 'clothes';
class DBHelper{
  var _db;
  
  Future<Database> get database async{
    _db = openDatabase
      (join(await getDatabasesPath(), 'clothes.db'),
      onCreate: (db,version){
        return db.execute(
            "CREATE TABLE clothes (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,gender TEXT,section TEXT,description TEXT,imagename TEXT,lowTemp INTEGER,highTemp INTEGER)"
        );
      },
      version: 1,
    );
    return _db;
  }
  
  Future<List<Clothes>> getAllDB() async{
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('clothes');
    if(maps.isEmpty) return [];
    List<Clothes> list = List.generate(maps.length, (index){
      return Clothes(
          id: maps[index]["id"],
          name: maps[index]['name'],
          gender: maps[index]['gender'],
          section:maps[index]['secton'],
          description: maps[index]['description'],
          imagename: maps[index]['imagename'],
          lowTemp: maps[index]['lowTemp'],
          highTemp: maps[index]['highTemp']);
    });
    return list;
  }

  getCloth(int Temp) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName WHERE id = ?', [Temp]);
    return res.isNotEmpty ? Clothes(id: res.first['id'], name: res.first['name']) : Null;
  }
}

