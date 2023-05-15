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
  String nowTempertyre = '0';

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
                SizedBox(
                  height: 75,
                ),
               // Text('test'),
                Text('${nowlocate}',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                Text('${now.hour}시 기준',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                weatherList.isNotEmpty
                    ? Text("${weatherList[4].fcstValue}°",style: TextStyle(fontSize: 120,fontWeight: FontWeight.bold),)
                    : Text("No data"),
              ],
            ),
          );
        },
      ),
    );
  }

}