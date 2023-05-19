import 'package:flutter/material.dart';
import 'package:wear_today/_View/MainPage.dart';
import 'package:wear_today/_Model/weatherModel.dart';
import 'package:wear_today/_Model/global.dart';
import 'package:wear_today/_DataSource/WeatherDataSource.dart';

import '../_ViewModel/findCategory.dart';

class settingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _settingPage();
  }
}

class _settingPage extends State<settingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
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
            SizedBox(
              height: 50,
            ),
            Text('프리셋 조정$sliderValue' ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
            Slider(value: sliderValue,
                min: -2,
                max: 2,
                divisions: 4,
                onChanged: (newValue){
              setState(() {
                sliderValue = newValue;
              });
                })
          ],
        ),
      ),
    );
  }
}
