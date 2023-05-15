import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wear_today/_ViewModel/DayweatherViewModel.dart';
import '../_DataSource/global.dart';
import '';

import '../_Model/weatherModel.dart';

class MainView extends StatefulWidget{
  const MainView({Key? key}) : super(key: key);
  @override
  State<MainView> createState(){
    return _MainViewState();
  }
}

class _MainViewState extends State<MainView> {
  late List<DayWeather> weatherList;
  var now = DateTime.now();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      /*appBar: AppBar(
        title: const Text('뭐입지?'),
      ),*/
      body: Consumer<DayWeatherViewModel>(
        builder: (context, provider, child){
          weatherList = provider.weatherList;
          return Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 75,
                ),
               // Text('test'),
                Text('$nowlocate',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                Text('${now.hour}시 기준',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                weatherList.isNotEmpty // 초기 리스트는 비어있으며, 삼항연산자를 통해 위젯 오류를 피함.
                    ? Text("${weatherList[12].fcstValue}°",style: TextStyle(fontSize: 120,fontWeight: FontWeight.bold),)
                    : Text("위치 수신을 기다리는 중..."),
              ],
            ),
          );
        },
      ),
    );
  }

}