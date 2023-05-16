import 'package:flutter/material.dart';
import '../_Model/weatherModel.dart';
import '../_Repository/DayWeatherRepo.dart';
import 'package:wear_today/_Model/global.dart';

String findTMP(int time, List<DayWeather> weatherList){ // 리스트에서 원하는 시간에 맞는 TMP 데이터만 찾아서 리턴.
  String rtime = "";
  if (time < 10) {
    rtime = '0${time}00'; // 0시 ~ 9시는 '0'000형식으로 rtime에 저장
  } else rtime ='${time}00'; //10~23시는 '00'00형식으로 rtime에 저장.

  for (DayWeather item in weatherList){
    if (item.category == 'TMP' && item.fcstTime == rtime) { // 요청한 rtime의 TMP데이터를 weatherList에서 찾아서 리턴.
      return '${item.fcstValue!}°';
    }
  }
  return "";
}

String findPOP(int time, List<DayWeather> weatherList){ // 리스트에서 원하는 시간에 맞는 POP 데이터만 찾아서 리턴.
  String rtime = "";
  if (time < 10) {
    rtime = '0${time}00'; // 0시 ~ 9시는 '0'000형식으로 rtime에 저장
  } else rtime ='${time}00'; //10~23시는 '00'00형식으로 rtime에 저장.

  for (DayWeather item in weatherList){
    if (item.category == 'POP' && item.fcstTime == rtime) { // 요청한 rtime의 TMP데이터를 weatherList에서 찾아서 리턴.
      return '${item.fcstValue!}';
    }
  }
  return "";
}

String findPTY(int time, List<DayWeather> weatherList){ // 리스트에서 원하는 시간에 맞는 POP 데이터만 찾아서 리턴.
  String rtime = "";
  if (time < 10) {
    rtime = '0${time}00'; // 0시 ~ 9시는 '0'000형식으로 rtime에 저장
  } else rtime ='${time}00'; //10~23시는 '00'00형식으로 rtime에 저장.

  for (DayWeather item in weatherList){
    if (item.category == 'PTY' && item.fcstTime == rtime) { // 요청한 rtime의 TMP데이터를 weatherList에서 찾아서 리턴.
      if (item.fcstValue == 0) {
        return "";
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

String findSKY(int time, List<DayWeather> weatherList){ // 리스트에서 원하는 시간에 맞는 POP 데이터만 찾아서 리턴.
  String rtime = "";
  if (time < 10) {
    rtime = '0${time}00'; // 0시 ~ 9시는 '0'000형식으로 rtime에 저장
  } else rtime ='${time}00'; //10~23시는 '00'00형식으로 rtime에 저장.

  for (DayWeather item in weatherList){
    if (item.category == 'SKY' && item.fcstTime == rtime) { // 요청한 rtime의 TMP데이터를 weatherList에서 찾아서 리턴.
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