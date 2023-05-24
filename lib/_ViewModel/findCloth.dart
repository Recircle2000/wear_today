import 'package:flutter/material.dart';
import '../_Model/weatherModel.dart';
import '../_Repository/DayWeatherRepo.dart';
import 'package:wear_today/_Model/global.dart';
import 'findCategory.dart';


int getScore(int time,List<DayWeather> weatherList){
  int temp = findWindChillTemp(time, weatherList);
  int custom = sliderValue.toInt();

  return temp + custom;
}

String season(int time, List<DayWeather> weatherList){
  int Score = getScore(time, weatherList);
  String Temp = "";
  bool freezing = Score < 4;
  bool cold = Score <=5 && Score < 9;
  bool cool = Score <=9 && Score < 12;
  bool mild = Score <=12 && Score < 17;
  bool warm = Score <=17 && Score < 20;
  bool hot = Score <=20 && Score < 23;
  bool veryHot = Score <=23 && Score < 28;
  bool exHot = Score >= 28;

  if (Score < 4) {
    return 'freezing';
  } else if (Score <=5 && Score < 9) {
    return 'cold';
  } else if (Score <=9 && Score < 12) {
    return 'cool';
  } else if (Score <=12 && Score < 17) {
    return 'mild';
  } else if (Score <=17 && Score < 20) {
    return 'warm';
  } else if (Score <=20 && Score < 23) {
    return 'hot';
  } else if (Score <=23 && Score < 28) {
    return 'veryHot';
  } else if (Score >= 28) {
    return 'exHot';
  } else return '';
}