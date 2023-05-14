import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wear_today/data_API/weatherData.dart';
import 'dart:convert';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: HttpApp(),
    );
  }
}

class HttpApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HttpApp();
}

class _HttpApp extends State<HttpApp> {
  String? result;
  int? yds;
  int? xds;
  double? Lti;
  String? Nlo;
  weatherData Weather = weatherData();
  void initState(){
    Weather.getWeather();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Http Example"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text('$yds'),
              Text('$xds'),
              Text('$Lti'),
              Text('$Nlo'),
            ],
          ),
        ),
      ),
      floatingActionButton:  FloatingActionButton(
        onPressed: () {
          Weather.getWeather();
          print('x좌표 : ${Weather.xCoordinate}');
          print('y좌표 : ${Weather.yCoordinate}');
          print('위도: ${Weather.Lati}');
          print('현재 위치(도시) : ${Weather.nowlocate}');
          print(Weather.nowWeather);
          //result = Weather.xCoordinate!;
          //getJSONData();
          setState(() {
            result = Weather.nowlocate;
            xds = Weather.xCoordinate;
            yds = Weather.yCoordinate;
            Lti = Weather.Lati;
            Nlo = Weather.nowlocate;
          });
        },
        child: Icon(Icons.file_download),
      ),
    );
  }

  Future<String> getJSONData() async{
    var url = 'https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=kSkqn5bgn8LgTC9jUY%2BCGqqcdIzVhyNl43a%2BbSfbU1QHu%2FrkFnB4Bc4b%2FEcdgltpoLhNfn3zSabBQJFmPGY13Q%3D%3D&pageNo=1&numOfRows=290&dataType=JSON&base_date=20230513&base_time=2300&nx=55&ny=127';
    var response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    return "SUC";
  }
}