import 'package:flutter/material.dart';
import '../_Model/weatherModel.dart';
import '../_Repository/DayWeatherRepo.dart';
import 'package:wear_today/_Model/global.dart';
import 'dart:math';

//풍속 = WSD, 강수확률 = POP, 온도 = TMP, 습도 = REH, 최저 = TMN, 최고 = TMX, 1시간 강수량 : PCP, 1시간 적설량 : SNO,
int findWeatherData(int time, List<DayWeather> weatherList, String itemV){ // 리스트에서 원하는 시간에 맞는 WSD 데이터만 찾아서 리턴.
  String rtime = "";
  if (time < 10) {
    rtime = '0${time}00'; // 0시 ~ 9시는 '0'000형식으로 rtime에 저장
  } else rtime ='${time}00'; //10~23시는 '00'00형식으로 rtime에 저장.

  if (itemV == 'TMX') {
    rtime = '1500';
  } else if (itemV == 'TMN') {
    rtime = '0600';
  }
  for (DayWeather item in weatherList){
    if (item.category == itemV && item.fcstTime == rtime) { // 요청한 rtime의 WSD데이터를 weatherList에서 찾아서 리턴.
      if (item.fcstValue! == '강수없음'||item.fcstValue! == '적설없음') {
        return 0;
      }
      else return item.fcstValue!.toInt();
    }
  }
  return 0;
}

//비/눈 정보가 없을땐 findSKY정보 자동 호출
String findPTY(int time, List<DayWeather> weatherList){ // 리스트에서 원하는 시간에 맞는 PTY 데이터만 찾아서 리턴.
  String rtime = "";
  if (time < 10) {
    rtime = '0${time}00'; // 0시 ~ 9시는 '0'000형식으로 rtime에 저장
  } else rtime ='${time}00'; //10~23시는 '00'00형식으로 rtime에 저장.

  for (DayWeather item in weatherList){
    if (item.category == 'PTY' && item.fcstTime == rtime) { // 요청한 rtime의 PTY데이터를 weatherList에서 찾아서 리턴.
      if (item.fcstValue == 0) {
        return findSKY(time, weatherList); //정보가 없을땐 findSKY정보 자동 호출
      } else if (item.fcstValue == 1) {
        return "비";
      } else if (item.fcstValue == 2) {
        return "비/눈";
      } else if (item.fcstValue == 3) {
        return "눈";
      } else {
        return "소나기";
      }
      //return '${item.fcstValue!}';
    }
  }
  return "";
}

//구름 정보 only
String findSKY(int time, List<DayWeather> weatherList){ // 리스트에서 원하는 시간에 맞는 SKY 데이터만 찾아서 리턴.
  String rtime = "";
  if (time < 10) {
    rtime = '0${time}00'; // 0시 ~ 9시는 '0'000형식으로 rtime에 저장
  } else rtime ='${time}00'; //10~23시는 '00'00형식으로 rtime에 저장.

  for (DayWeather item in weatherList){
    if (item.category == 'SKY' && item.fcstTime == rtime) { // 요청한 rtime의 SKY데이터를 weatherList에서 찾아서 리턴.
      if (item.fcstValue == 1) {
        return "맑음";
      } else if (item.fcstValue == 3) {
        return "구름많음";
      } else return "흐림";
      //return '${item.fcstValue!}';
    }

  }
  return "";
}


int findWindChillTemp(int time, List<DayWeather> weatherList){
  int fTemp=0;
  double rTemp = (findWeatherData(time, weatherList,'TMP')).toDouble();
  fTemp = (35.74 + (0.6215 * rTemp) - (35.75 * pow(findWeatherData(time, weatherList,'WSD'), 0.16)) + (0.4275 * rTemp * pow(findWeatherData(time, weatherList,'WSD'), 0.16))).toInt();
  return fTemp;
}

int getScore(int time,List<DayWeather> weatherList){
  int temp = findWindChillTemp(time, weatherList);
  int custom = sliderValue.toInt();

  return temp + custom;
}

