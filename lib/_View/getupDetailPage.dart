import 'dart:io';

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
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black,),
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
            Text("${now.hour + widget.index}시 $nowLocate의 날씨는...",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold),),
            Text('${findTMP(now.hour + widget.index, widget.weatherList)}°',
              style: TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.bold),),
            Text('체감온도 : ${findWindChillTemp(now.hour + widget.index, widget.weatherList)}°',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold),),
            Text('${dbProvider.getnotice(findPTY(now.hour + widget.index, widget.weatherList))}'),
            FutureBuilder<String>(
              future: dbProvider.getTopImagePath(getScore(now.hour + widget.index, widget.weatherList)),
              builder: (context, snapshot) {
                final imagePath = snapshot.data!;
                final isAssetImage = imagePath.startsWith('assets/');
                Widget imageWidget;
                if (snapshot.hasData) {
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
                  return imageWidget;
                } else if (snapshot.hasError) {
                  // 에러 처리
                  return Text('Error: ${snapshot.error}');
                } else {
                  // 데이터 로딩 중이므로 로딩 표시
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}