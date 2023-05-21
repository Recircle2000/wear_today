import 'package:flutter/material.dart';
import '../_Model/weatherModel.dart';
import '../_Repository/DayWeatherRepo.dart';
import 'package:wear_today/_Model/global.dart';
import 'findCategory.dart';

String season(int time, List<DayWeather> weatherList){
  int temp = findTMP(time, weatherList);

  bool freezing = temp < 4;
  bool cold = temp <=5 && temp < 9;
  bool cool = temp <=9 && temp < 12;
  bool mild = temp <=12 && temp < 17;
  bool warm = temp <=17 && temp < 20;
  bool hot = temp <=20 && temp < 23;
  bool veryHot = temp <=23 && temp < 28;
  bool exHot = temp >= 28;



  return "null";
}

 List<Map<String,String>> listup_clothes_main(int time, List<DayWeather> weatherList,int num){

   return null;
 }