import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wear_today/_View/MainPage.dart';
import 'package:wear_today/_Model/weatherModel.dart';
import 'package:wear_today/_Model/global.dart';
import 'package:wear_today/_DataSource/WeatherDataSource.dart';
import '../_ViewModel/DBViewModel.dart';
import '../_ViewModel/DayweatherViewModel.dart';
import '../_ViewModel/findCategory.dart';

class debug extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _debug();
  }
}

class _debug extends State<debug> {
  Gender? selectedGender;
  late List<DayWeather> weatherList;
  late List<Map<String, dynamic>> dbList;
  @override
  Widget build(BuildContext context) {
    DBViewModel dbProvider = Provider.of<DBViewModel>(context);
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
            body: Column(
              children: [
                Text('nowLocate : $nowLocate'),
                Text('updageLocate : $updateLocate'),
                Text('sliderValue : $sliderValue'),
                Text('inputlocation $inputLocation'),
              ],
            ),
            //여기에 UI구축
          );

  }
}
