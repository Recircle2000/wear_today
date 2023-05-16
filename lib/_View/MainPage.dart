import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wear_today/_View/getupDetailPage.dart';
import 'package:wear_today/_ViewModel/DayweatherViewModel.dart';
import '../_Model/global.dart';
import '../_ViewModel/findCategory.dart';

import '../_Model/weatherModel.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() {
    return _MainViewState();
  }
}

class _MainViewState extends State<MainView> {
  late List<DayWeather> weatherList;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Text('뭐입지?'),
      ),*/
      body: Consumer<DayWeatherViewModel>(
        builder: (context, provider, child) {
          weatherList = provider.weatherList;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 75,
                ),
                // Text('test'),
                Icon(Islocate),
                Text(
                  '$nowlocate',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${now.hour}시 기준',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                weatherList.isNotEmpty // 초기 리스트는 비어있으며, 삼항연산자를 통해 위젯 오류를 피함.
                    ? Text(
                        "${findTMP(now.hour, weatherList)}",
                        style: TextStyle(
                            fontSize: 120, fontWeight: FontWeight.bold),
                      )
                    : Text("위치 수신을 기다리는 중..."),
                Text(
                  "${findSKY(now.hour, weatherList)}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${findPTY(now.hour, weatherList)}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: (24 - (now.hour)), // 오늘 날짜까지만 보여주는 앱.
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              Navigator.push(context,
                              MaterialPageRoute(builder: (context) => getupDetailPage(
                                weatherList: weatherList,
                                index: index,
                              )),
                              );
                            },

                          child: Card(
                            margin: EdgeInsets.only(top: 15),
                              color: Colors.blue[50],
                              shape: RoundedRectangleBorder(  //모서리를 둥글게 하기 위해 사용
                              borderRadius: BorderRadius.circular(30.0),
                              ),
                            elevation: 20.0,
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${index +1}시간 뒤'),
                                      Text(
                                        '${findTMP(now.hour + index, weatherList)}',
                                        style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('${findSKY(now.hour + index, weatherList)}')
                                    ],
                                  ),
                                ),
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
}
