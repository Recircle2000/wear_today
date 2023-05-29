import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wear_today/_ViewModel/DBViewModel.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../_Model/global.dart';
import '../_ViewModel/findCategory.dart';

class settingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _settingPage();
  }
}

class _settingPage extends State<settingPage> {
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
        backgroundColor: Colors.white,
        title: Text('DB관리',style: TextStyle(color: Colors.black,),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: () {
            // 뒤로 가기 버튼 클릭 시 이전 페이지로 돌아감
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              imagePath = await _takePhoto();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("DB 추가"),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          imagePath != null
                              ? Image.file(File(imagePath!))
                              : Text("q"),
                          TextField(
                            onChanged: (value) => name = value,
                            decoration: InputDecoration(labelText: '영어이름'),
                          ),
                          DropdownButtonFormField<String>(
                            value: section,
                            onChanged: (String? value) {
                              setState(() {
                                section = value;
                              });
                            },
                            items: const <DropdownMenuItem<String>>[
                              DropdownMenuItem<String>(
                                value: 'top',
                                child: Text('상의'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'under',
                                child: Text('하의'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'acc',
                                child: Text('악세서리'),
                              ),
                            ],
                            decoration: const InputDecoration(
                              labelText: '카테고리',
                            ),
                          ),
                          TextField(
                            onChanged: (value) => description = value,
                            decoration: InputDecoration(labelText: '설명'),
                          ),
                          TextField(
                            onChanged: (value) => lowTemp = int.tryParse(value),
                            decoration: InputDecoration(labelText: '최저온도'),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            onChanged: (value) =>
                                highTemp = int.tryParse(value),
                            decoration: InputDecoration(labelText: '최고온도'),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            child: Text('취소'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Fluttertoast.showToast(msg: "DB추가가 완료되었습니다.");
                              final convertedData = await _convert();
                              setState(() {
                                dbProvider.insertRecord(convertedData);
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text('저장'),
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            },
            child: Text('갤러리에서 DB 추가하기'),
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

                      // 이미지 파일의 경로 확인
                      final imagePath = record['imagePath'];
                      final isAssetImage = imagePath.startsWith('assets/');

                      // 이미지 위젯 생성
                      Widget imageWidget;
                      if (isAssetImage) {
                        // 앱 번들에 있는 이미지인 경우
                        imageWidget = Image.asset(
                          imagePath,
                          width: 80,
                          height: 80,
                        );
                      } else {
                        // 앱 번들에 없는 이미지인 경우
                        imageWidget = Image.file(
                          File(imagePath),
                          width: 80,
                          height: 80,
                        );
                      }
                      // 필요한 데이터를 추출하여 UI에 출력하거나 다른 작업 수행
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        child: InkWell(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('삭제 확인'),
                                  content: Text('삭제하시겠습니까?'),
                                  actions: [
                                    TextButton(
                                      child: Text('취소'),
                                      onPressed: () {
                                        Navigator.of(context).pop(); // 다이얼로그 닫기
                                      },
                                    ),
                                    TextButton(
                                      child: Text('삭제'),
                                      onPressed: () async {
                                        Fluttertoast.showToast(msg: "DB삭제가 완료되었습니다.");
                                        dbProvider
                                            .deleteRecord(record['imagePath']);
                                        Navigator.of(context).pop(); // 다이얼로그 닫기
                                        setState(() {
                                          // 필요한 상태 업데이트
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              imageWidget,
                              SizedBox(
                                width: 40,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    record['name'],
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(record['description'],
                                      textAlign: TextAlign.left),
                                ],
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "최저 : ${record['lowTemp']}",
                                    textAlign: TextAlign.left,
                                  ),
                                  Text("최고 : ${record['highTemp']}",
                                      textAlign: TextAlign.left),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return SpinKitPulse(
                    color: Colors.black,
                    size: 100,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _takePhoto() async {
    var savedImage;
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(image.path);
      savedImage = await File(image.path).copy('${appDir.path}/$fileName');
    }
    return savedImage.path;
  }

  void updateWidget() {
    setState(() {});
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
        'gender': 'public',
      };
      return convMap;
      // 데이터 저장 후 다른 동작 수행
    } else {
      return convMap;
      // 필요한 모든 필드를 입력하지 않은 경우에 대한 예외 처리
    }
  }
}
