import 'package:flutter/material.dart';
import 'package:wear_today/_View/MainPage.dart';
import 'package:wear_today/_Model/weatherModel.dart';
import 'package:wear_today/_Model/global.dart';
import 'package:wear_today/_DataSource/WeatherDataSource.dart';

import '../_ViewModel/findCategory.dart';

class getupDetailPage extends StatefulWidget{
  final List<DayWeather> weatherList;
  final int index;

  getupDetailPage({required this.weatherList, required this.index});
  @override
  State<StatefulWidget> createState(){
    return _getupDetailPage();
  }
}

class _getupDetailPage extends State<getupDetailPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 뒤로 가기 버튼 클릭 시 이전 페이지로 돌아감
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text('${findTMP(now.hour + widget.index, widget.weatherList)}',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold),),
            //Text('test'),
          ],
        ),
      ),
    );
  }
}