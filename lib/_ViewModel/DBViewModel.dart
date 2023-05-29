import '../_Repository/DB_Repo.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

class DBViewModel extends ChangeNotifier {
  DBRepo dbRepo = DBRepo();
  List<Map<String, dynamic>> records = [];

  Future<List<Map<String, dynamic>>> getRecords() async {
    records = await dbRepo.getRecords();
    return records;
    notifyListeners();
  }

  Future<void> rawQuery(String query) async {
    records = await dbRepo.rawQuery(query);
    notifyListeners();
  }

  final lock = Lock();

  Future<String> getTopImagePath(int Temp, {int value = 0}) async {

    return await lock.synchronized(() async { // .synchronized DB 동시 호출시 충돌 오류를 막고자 패키지 사용. 여러 스레드에서 동시 호출되어도 DB에러가 발생하지 않음.
      records = await dbRepo.rawQuery("SELECT imagePath FROM clothes WHERE lowTemp <= $Temp and highTemp >= $Temp and section = 'top' and gender = 'public'");
      if (records.isNotEmpty) {
        return records[0]["imagePath"];
      } else {
        return "assets/clothes/No_image.png";
      }
    });
  }
  Future<String> getUnderImagePath(int Temp, {int value = 0}) async {;
    return await lock.synchronized(() async {// .synchronized DB 동시 호출시 충돌 오류를 막고자 패키지 사용. 여러 스레드에서 동시 호출되어도 DB에러가 발생하지 않음.
      records = await dbRepo.rawQuery("SELECT imagePath FROM clothes WHERE lowTemp <= $Temp and highTemp >= $Temp and section = 'under' and gender = 'public'");
      if (records.isNotEmpty) {
        return records[0]["imagePath"];
      } else {
        return "assets/clothes/No_image.png";
      }
    });
  }

  Future<List> getTopImageAllPath(int Temp, {int value = 0}) async {
    return await lock.synchronized(() async { // .synchronized DB 동시 호출시 충돌 오류를 막고자 패키지 사용. 여러 스레드에서 동시 호출되어도 DB에러가 발생하지 않음.
      records = await dbRepo.rawQuery("SELECT imagePath FROM clothes WHERE lowTemp <= $Temp and highTemp >= $Temp and section = 'top'");
      if (records.isNotEmpty) {
        return records;
      } else return records;
    });
  }

  Future<List> getUnderImageAllPath(int Temp, {int value = 0}) async {;
  return await lock.synchronized(() async {// .synchronized DB 동시 호출시 충돌 오류를 막고자 패키지 사용. 여러 스레드에서 동시 호출되어도 DB에러가 발생하지 않음.
    records = await dbRepo.rawQuery("SELECT imagePath FROM clothes WHERE lowTemp <= $Temp and highTemp >= $Temp and section = 'under'");
    if (records.isNotEmpty) {
      return records;
    } else return records;
  });
  }

  Future<String> gettest() async {
    return await lock.synchronized(() async {// .synchronized DB 동시 호출시 충돌 오류를 막고자 패키지 사용. 여러 스레드에서 동시 호출되어도 DB에러가 발생하지 않음.
      records = await dbRepo.rawQuery("SELECT imagePath FROM clothes WHERE section = 'test'");
      if (records.isNotEmpty) {
        return records[0]["imagePath"];
      } else {
        return "assets/clothes/No_image.png";
      }
    });
  }

  Future<String> getnotice(String Weat) async {
    return await lock.synchronized(() async {// .synchronized DB 동시 호출시 충돌 오류를 막고자 패키지 사용. 여러 스레드에서 동시 호출되어도 DB에러가 발생하지 않음.
      records = await dbRepo.rawQuery("SELECT notice FROM notice WHERE weather = '$Weat'");
      if (records.isNotEmpty) {
        return records[0]["weather"];
      } else {
        return "";
      }
    });
  }

  Future<void> insertRecord(Map<String, dynamic> record) async {
    await dbRepo.insertRecord(record);
    notifyListeners();
  }

  Future<void> deleteRecord(String imagePath) async {
    await dbRepo.deleteRecord(imagePath);
    notifyListeners();
  }
}