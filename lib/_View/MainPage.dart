import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wear_today/_View/getupDetailPage.dart';
import 'package:wear_today/_View/settingPage.dart';
import 'package:wear_today/_ViewModel/DBViewModel.dart';
import 'package:wear_today/_ViewModel/DayweatherViewModel.dart';
import '../_Model/global.dart';
import '../_ViewModel/findCategory.dart';
import '../_Model/weatherModel.dart';
import 'settingPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  late List<DayWeather> weatherList;
  late List<Map<String, dynamic>> dbList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Text('뭐입지?'),
      ),*/
      body: Consumer2<DayWeatherViewModel, DBViewModel>( // 구독한 View모델을 소비.
        builder: (context, weatherProvider, dbProvider, child) {
          weatherList = weatherProvider.weatherList; // ViewModel참조
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                //위치 변경
                                title: Text("현재 위치 : $nowLocate"),
                                content: TextField(
                                  decoration:
                                      InputDecoration(hintText: "위치 입력"),
                                  onChanged: (value) {
                                    setState(() {
                                      updateLocate = value;
                                      inputLocation = value;
                                    });
                                  },
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("취소"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            weatherList = [];
                                            print(weatherList);
                                            weatherProvider
                                                .refreshWeatherList()
                                                .then((_) {
                                              print(weatherList);
                                            });
                                            nowLocate = updateLocate;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("적용"),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          // 동그란 모양의 버튼
                          padding: EdgeInsets.all(16.0),
                          // 버튼 패딩 설정
                          primary: Colors.lightBlue[50],
                          elevation: 4,
                          shadowColor: Colors.black,
                        ),
                        child: Icon(
                          Icons.add_location_alt,
                          color: Colors.black,
                        )),
                    Icon(islocate),
                    ElevatedButton(
                      //DB설정 페이지 푸시
                        onPressed: () {
                          Fluttertoast.showToast(msg: "정보를 꾹 누르면 삭제 할 수 있어요.");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MultiProvider( // settingPage에서도 소비가 가능해야함. 위젯 트리 구조가 settingPage가 하위 위젯이 아니라고해서 부득이하게 구독을 다시 함.
                                  providers: [
                                    ChangeNotifierProvider<DayWeatherViewModel>(
                                      create: (context) => DayWeatherViewModel(),
                                    ),
                                    ChangeNotifierProvider<DBViewModel>(
                                      create: (context) => DBViewModel(),
                                    ),
                                  ],
                                  child: settingPage()
                              ),),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          // 동그란 모양의 버튼
                          padding: EdgeInsets.all(16.0),
                          // 버튼 패딩 설정
                          primary: Colors.lightBlue[50],
                          elevation: 4,
                          shadowColor: Colors.black,
                        ),
                        child: Icon(
                          Icons.settings,
                          color: Colors.black,
                        )),
                  ],
                ),
                // Text('test'),
                Text(
                  '$nowLocate',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                ),
                weatherList.isNotEmpty // 초기 리스트는 비어있으며, 삼항연산자를 통해 위젯 오류를 회피함.
                    ? Text(
                        "${findWeatherData(now.hour, weatherList,'TMP')}°",
                        style: TextStyle(
                            fontSize: 120, fontWeight: FontWeight.w300),
                      )
                    : Text(''),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    weatherList.isNotEmpty // 초기 리스트는 비어있으며, 삼항연산자를 통해 위젯 오류를 피함.
                        ? Text(
                      "${findWeatherData(now.hour, weatherList,'TMN')}°",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    )
                        : Text(''),
                    weatherList.isNotEmpty // 초기 리스트는 비어있으며, 삼항연산자를 통해 위젯 오류를 피함.
                        ? Text(
                      " / ${findWeatherData(now.hour, weatherList,'TMX')}°",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    )
                        : SpinKitPulse( // 다양한 로딩 애니메이션 패키지
                      color: Colors.black,
                      size: 100,
                    ),
                  ],
                ),
                Text(
                  "${findPTY(now.hour, weatherList)}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                    child: ListView.builder(
                      //현재 시간 ~ 23시 까지의 데이터를 보여줌.
                      cacheExtent: 100,
                        itemCount: (24 - (now.hour)),
                        itemBuilder: (context, index) {
                          return InkWell(
                            //터지 감지
                            onTap: () {
                              weatherList.isNotEmpty ?
                              Navigator.push(
                                context,
                                  MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    //위젯 트리 구조를 해결하였다면 MultiProvider 재호출 안하고도 자동으로 하위 위젯도 구독이 되어야 함.
                                  providers: [
                                    ChangeNotifierProvider<DayWeatherViewModel>(
                                      create: (context) => DayWeatherViewModel(),
                                    ),
                                    ChangeNotifierProvider<DBViewModel>(
                                      create: (context) => DBViewModel(),
                                    ),
                                  ],
                                  child: getupDetailPage(
                                    weatherList: weatherList,
                                    index: index,
                                        )),
                              ),
                              ) : Fluttertoast.showToast(msg: "데이터를 불러오고 있어요.");
                            },

                            child: Card(
                              //각각의 리스트 내부에 구현.
                              margin: EdgeInsets.only(top: 15),
                              color: Colors.blue[50],
                              //카드 색상
                              shape: RoundedRectangleBorder(
                                //모서리를 둥글게 하기 위해 사용
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              elevation: 20.0,
                              //그림자
                              child: Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('${now.hour + index}시'),
                                        weatherList
                                                .isNotEmpty // 초기 리스트는 비어있으며, 삼항연산자를 통해 위젯 오류를 피함.
                                            ? Text(
                                                "${findWeatherData(now.hour + index, weatherList, 'TMP')}°",
                                                style: TextStyle(
                                                    fontSize: 40,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              )
                                            : SpinKitThreeBounce(
                                          color: Colors.black12,
                                          size: 20,
                                        ),
                                        Text(
                                          '${findPTY(now.hour + index, weatherList)}',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 290,
                                    height: 100,
                                    color: Colors.blue[50],
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        weatherList
                                                .isNotEmpty // 초기 리스트는 비어있으며, 삼항연산자를 통해 위젯 오류를 피함.
                                            ? FutureBuilder<String>(
                                          future: dbProvider.getTopImagePath(getScore(now.hour + index, weatherList)),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData && snapshot.data != null) {
                                              final imagePath = snapshot.data!;
                                              final isAssetImage = imagePath.startsWith('assets/');
                                              Widget imageWidget;
                                              // 기존 데이터는 asset이지만 사용자가 추가한 데이터는 asset이 아닌 내부 디렉토리에 저장됨. 따라서 파일명을 구분하는 로직을 추가함.
                                              if (isAssetImage) {
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
                                              return imageWidget;

                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              return SpinKitWave(
                                                color: Colors.black,
                                                size: 20,
                                              );
                                            }
                                          },
                                        )
                                            : Text(''),
                                        //Text("${dbProvider.getURL(findWindChillTemp(now.hour + index, weatherList))}"),
                                        weatherList
                                            .isNotEmpty // 초기 리스트는 비어있으며, 삼항연산자를 통해 위젯 오류를 피함.
                                            ? FutureBuilder<String>(
                                          future: dbProvider.getUnderImagePath(getScore(now.hour + index, weatherList)),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData && snapshot.data != null) {
                                            final imagePath = snapshot.data!;
                                            final isAssetImage = imagePath.startsWith('assets/');
                                            Widget imageWidget;
                                            // 기존 데이터는 asset이지만 사용자가 추가한 데이터는 asset이 아닌 내부 디렉토리에 저장됨. 따라서 파일명을 구분하는 로직을 추가함.
                                              if (isAssetImage) {
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
                                              return imageWidget;

                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              return SpinKitWave(
                                                color: Colors.black,
                                                size: 20,
                                              );
                                            }
                                          },
                                        )
                                            : Text(''),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        })),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<String> get1URL(int Temp) {
    DBViewModel dbViewModel = DBViewModel();
    return dbViewModel.getTopImagePath(Temp);
  }

  Future<String> get2URL(int Temp) {
    DBViewModel dbViewModel = DBViewModel();
    return dbViewModel.getUnderImagePath(Temp);
  }
}
