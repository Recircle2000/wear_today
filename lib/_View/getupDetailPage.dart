import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wear_today/_View/MainPage.dart';
import 'package:wear_today/_Model/weatherModel.dart';
import 'package:wear_today/_Model/global.dart';
import 'package:wear_today/_DataSource/WeatherDataSource.dart';
import '../_ViewModel/DBViewModel.dart';
import '../_ViewModel/findCategory.dart';

class getupDetailPage extends StatefulWidget {
  final List<DayWeather> weatherList;
  final int index;

  getupDetailPage({required this.weatherList, required this.index});

  @override
  State<StatefulWidget> createState() {
    return _getupDetailPage();
  }
}

class _getupDetailPage extends State<getupDetailPage> {
  @override
  Widget build(BuildContext context) {
    DBViewModel dbProvider = Provider.of<DBViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            // 뒤로 가기 버튼 클릭 시 이전 페이지로 돌아감
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            //테스트용
            SizedBox(
              width: 20,
              height: 20,
            ),
            Text(
              "${now.hour + widget.index}시 $nowLocate의 날씨는...",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${findWeatherData(now.hour + widget.index, widget.weatherList, 'TMP')}°',
                  style: TextStyle(fontSize: 100, fontWeight: FontWeight.w300),
                ),
                Column(
                  children: [
                    Text(
                      '강수확률 : ${findWeatherData(now.hour + widget.index, widget.weatherList, 'POP')}%',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      '습도 : ${findWeatherData(now.hour + widget.index, widget.weatherList, 'REH')}%',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      '바람 : ${findWeatherData(now.hour + widget.index, widget.weatherList, 'WSD')}m/s',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      '체감온도 : ${findWindChillTemp(now.hour + widget.index, widget.weatherList)}°',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "이렇게 입어 보는건 어때요?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 190,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 0), // 그림자의 위치 조정 가능
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text("상의"),
                          Expanded(
                            child: FutureBuilder<List>(
                              future: Future.wait([
                                dbProvider.getTopImageAllPath(findWindChillTemp(
                                    now.hour + widget.index,
                                    widget.weatherList)),
                                dbProvider.getTopImageAllPath(
                                    findWindChillTemp(now.hour + widget.index,
                                        widget.weatherList),
                                    value: 0,
                                    value2: false),
                              ]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // 로딩 중일 때
                                  return Text('');
                                } else if (snapshot.hasError) {
                                  // 에러가 발생했을 때
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  // 데이터를 받아왔을 때
                                  List? recordList = snapshot.data![0];
                                  List? recordList2 = snapshot.data![1];
                                  return ListView.builder(
                                    itemCount: recordList?.length,
                                    itemBuilder: (context, index) {
                                      String description = recordList![index];
                                      String imagePath = recordList2![index];
                                      final isAssetImage =
                                          imagePath.startsWith('assets/');
                                      Widget imageWidget;
                                      if (isAssetImage) {
                                        imageWidget = Image.asset(
                                          imagePath,
                                          width: 60,
                                          height: 60,
                                        );
                                      } else {
                                        // 앱 번들에 없는 이미지인 경우
                                        imageWidget = Image.file(
                                          File(imagePath),
                                          width: 60,
                                          height: 60,
                                        );
                                      }

                                      // 각 아이템에 대한 UI 구성 및 반환
                                      return ListTile(
                                          title: Column(
                                        children: [
                                          Row(
                                            children: [
                                              imageWidget,
                                              Text(
                                                description,
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          )
                                        ],
                                      ));
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 190,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 0), // 그림자의 위치 조정 가능
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text("하의"),
                          Expanded(
                            child: FutureBuilder<List>(
                              future: Future.wait([
                                dbProvider.getUnderImageAllPath(
                                    findWindChillTemp(now.hour + widget.index,
                                        widget.weatherList)),
                                dbProvider.getUnderImageAllPath(
                                    findWindChillTemp(now.hour + widget.index,
                                        widget.weatherList),
                                    value: 0,
                                    value2: false),
                              ]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // 로딩 중일 때
                                  return Text('');
                                } else if (snapshot.hasError) {
                                  // 에러가 발생했을 때
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  // 데이터를 받아왔을 때
                                  List? recordList = snapshot.data![0];
                                  List? recordList2 = snapshot.data![1];
                                  return ListView.builder(
                                    itemCount: recordList?.length,
                                    itemBuilder: (context, index) {
                                      String description = recordList![index];
                                      String imagePath = recordList2![index];
                                      final isAssetImage =
                                          imagePath.startsWith('assets/');
                                      Widget imageWidget;
                                      if (isAssetImage) {
                                        imageWidget = Image.asset(
                                          imagePath,
                                          width: 60,
                                          height: 60,
                                        );
                                      } else {
                                        // 앱 번들에 없는 이미지인 경우
                                        imageWidget = Image.file(
                                          File(imagePath),
                                          width: 60,
                                          height: 60,
                                        );
                                      }

                                      // 각 아이템에 대한 UI 구성 및 반환
                                      return ListTile(
                                        title: Column(
                                          children: [
                                            Row(
                                              children: [
                                                imageWidget,
                                                Text(
                                                  description,
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            /*Text(
              "이것도 챙겨봐요!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),*/
            SizedBox(
              height: 10,
            ),
            Container(
              width: 400,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 0), // 그림자의 위치 조정 가능
                  ),
                ],
              ),
              child: Center(
                child: Text("맘에 들지 않는 옷이 있거나 넣고싶은 옷이 있으세요? \n 설정으로 이동해서 나만의 데이터 베이스를 만들어 봐요!", textAlign: TextAlign.center,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
