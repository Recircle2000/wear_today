import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  //입력한 데이터를 DB에 넣기전에 임시 저장.
  String? imagePath;
  String? name;
  String? section;
  String? description;
  int? lowTemp;
  int? highTemp;
  TextEditingController val1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DBViewModel dbProvider = Provider.of<DBViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('데이터 베이스 관리',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
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
            style:(
            ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[50]!),
            )
            ),
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
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                              //정규표현식 사용. 영어만 입력가능. 띄어쓰기x
                            ],
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
                            decoration: InputDecoration(labelText: '이름'),
                          ),
                          TextField(
                            onChanged: (value) => lowTemp = int.tryParse(value),
                            decoration: InputDecoration(labelText: '최저온도'),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, //숫자 only
                            ],
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            onChanged: (value) =>
                                highTemp = int.tryParse(value),
                            decoration: InputDecoration(labelText: '최고온도'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, //숫자 only
                            ],
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
                              //6개 항목(이미지 파일 포함)이 모두 입력되어야 DB에 추가함.
                              if (imagePath != null &&
                                  name != null &&
                                  section != null &&
                                  description != null &&
                                  lowTemp != null &&
                                  highTemp != null) {
                                Fluttertoast.showToast(msg: "DB를 추가했어요.");
                                final convertedData = await _convert();
                                setState(() {
                                  dbProvider.insertRecord(convertedData);
                                });
                                imagePath = null;
                                name = null;
                                section = null;
                                description  = null;
                                lowTemp  = null;
                                highTemp  = null;
                                Navigator.of(context).pop();
                              }else {
                                Fluttertoast.cancel();
                                Fluttertoast.showToast(msg: "항목을 모두 입력해주세요.",backgroundColor: Colors.red,toastLength: Toast.LENGTH_SHORT,);
                              }

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
            child: Text('갤러리에서 사진 추가하기',style: TextStyle(color: Colors.black),),
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
                                        Fluttertoast.showToast(msg: "DB를 삭제했어요.");
                                        dbProvider.deleteRecord(record['imagePath']);
                                        Navigator.of(context).pop();
                                        setState(() {

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
    if (imagePath != null && name != null &&
        section != null && description != null &&
        lowTemp != null && highTemp != null) {
      convMap = {
        'imagePath': imagePath,
        'name': name,
        'section': section,
        'description': description,
        'lowTemp': lowTemp,
        'highTemp': highTemp,
        'gender': 'public',
      }; return convMap;
      // 데이터 저장 후 다른 동작 수행
    } else { return convMap;
      // 필요한 모든 필드를 입력하지 않은 경우에 대한 예외 처리
    }
  }
}
