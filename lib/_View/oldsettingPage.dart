import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wear_today/_ViewModel/DBViewModel.dart';

import '../_Model/global.dart';
import '../_ViewModel/findCategory.dart';

class oldSettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _oldSettingPage();
  }
}

class _oldSettingPage extends State<oldSettingPage> {
  String? imagePath;
  String? name;
  String? section;
  String? description;
  int? lowTemp;
  int? highTemp;

  @override
  Widget build(BuildContext context) {
    DBViewModel dbProvider = Provider.of<DBViewModel>(context);
    return Scaffold(
      appBar: AppBar(
         title: Text('DB관리'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 뒤로 가기 버튼 클릭 시 이전 페이지로 돌아감
            Navigator.pop(context);
          },
        ),
      ),

        body: Column(
          children: [
            ElevatedButton(
              onPressed: _takePhoto,
              child: Text('Take Photo'),
            ),
            if (imagePath != null) Image.file(File(imagePath!)),
            TextField(
              onChanged: (value) => name = value,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              onChanged: (value) => section = value,
              decoration: InputDecoration(labelText: 'Section'),
            ),
            TextField(
              onChanged: (value) => description = value,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              onChanged: (value) => lowTemp = int.tryParse(value),
              decoration: InputDecoration(labelText: 'Low Temp'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              onChanged: (value) => highTemp = int.tryParse(value),
              decoration: InputDecoration(labelText: 'High Temp'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () async {
                await dbProvider.insertRecord(await _convert());
              },
              child: Text('Save Data'),
            ),
              Expanded(
             child: FutureBuilder<List<Map<String, dynamic>>>(
                future: dbProvider.getRecords(), // 데이터 가져오는 비동기 함수 호출
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final records = snapshot.data!;
                    return ListView.builder(
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final record = records[index];
                        // 필요한 데이터를 추출하여 UI에 출력하거나 다른 작업 수행
                        return Card(
                          child: Row(
                            children: [
                              Image.asset(record['imagePath'],
                                width: 70,
                                height: 70, ),
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(record['name']),
                                  Text(record['description']),
                                ],
                              )

                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              ),
          ],
        ),
      );

  }

  Future<void> _takePhoto() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imagePath = image?.path;
    });
  }

  Future<Map<String, dynamic>> _convert() async {
    Map<String, dynamic> convMap = {};
    if (imagePath != null &&
        name != null &&
        section != null &&
        description != null &&
        lowTemp != null &&
        highTemp != null) {
      convMap = {
        'imagePath': imagePath,
        'name': name,
        'section': section,
        'description': description,
        'lowTemp': lowTemp,
        'highTemp': highTemp,
      };
      return convMap;
      // 데이터 저장 후 다른 동작 수행
    } else {
      return convMap;
      // 필요한 모든 필드를 입력하지 않은 경우에 대한 예외 처리
    }
  }
}
