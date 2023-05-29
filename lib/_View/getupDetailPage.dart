import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wear_today/_View/MainPage.dart';
import 'package:wear_today/_Model/weatherModel.dart';
import 'package:wear_today/_Model/global.dart';
import 'package:wear_today/_DataSource/WeatherDataSource.dart';

import '../_ViewModel/DBViewModel.dart';
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
    DBViewModel dbProvider = Provider.of<DBViewModel>(context);
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
            //테스트용
            Text('${findTMP(now.hour + widget.index, widget.weatherList)}',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold),),
            widget.weatherList
                .isNotEmpty // 초기 리스트는 비어있으며, 삼항연산자를 통해 위젯 오류를 피함.
                ? FutureBuilder<String>(
              future: dbProvider.get1URL(getScore(now.hour + widget.index, widget.weatherList)),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.asset("${snapshot.data!}",
                    width: 70,
                    height: 70,);
                  //return Text(snapshot.data!);
                } else if (snapshot
                    .hasError) {
                  return Text(
                      'Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
                : Text(''),
            //Text('test'),
          ],
        ),
      ),
    );
  }
}