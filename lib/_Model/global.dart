import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import '../_DataSource/location.dart';
import '../_DataSource/WeatherDataSource.dart';
import 'weatherModel.dart';
import '../_Repository/DayWeatherRepo.dart';
import '../_ViewModel/DayweatherViewModel.dart';
import '../_View/MainPage.dart';

// 그냥 전역 변수 저장하는 곳.

String? nowLocate = '위치 수신 중..'; //현재 위치, View_Mainpage에서 사용.
String? updateLocate = '';
IconData islocate = Icons.location_off_outlined;
var now = DateTime.now();
double sliderValue = 0;
String? inputLocation = "위치 입력";
enum Gender { male, female }
