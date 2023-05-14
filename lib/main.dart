import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:wear_today/mainPage.dart';
import 'package:wear_today/loading.dart';
import 'package:wear_today/data_API/weatherData.dart';
import 'package:wear_today/data_API/location.dart';

void main() {
  MyLocation myLocation = MyLocation();
  weatherData weather = weatherData();
  runApp(MyApp(myLocation: myLocation, weather: weather));
}

class MyApp extends StatelessWidget {
  final MyLocation myLocation;
  final weatherData weather;
  const MyApp({Key? key, required this.myLocation, required this.weather}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'wear_Tod',
      debugShowCheckedModeBanner: false,
      home: mainPage(myLocation: myLocation, weather: weather),
    );
  }
}
