import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:wear_today/data_API/location.dart';
import 'package:wear_today/ViewModels/weatherData_View.dart';
import 'package:wear_today/main/hourPage.dart';
import 'package:wear_today/mainPage.dart';
import 'package:wear_today/main.dart';


class weatherData extends {
  final MyLocation _myLocation = MyLocation();

  var now = DateTime.now();
  String? baseTime; // 기준 시간
  String? baseDate; // 기준 날짜
  int? xCoordinate; // 변환된 x좌표
  int? yCoordinate; // 변환된 y좌표
  double? Lati; // 위도
  double? Longi; // 경도
  String? nowlocate; //현재 위치


  String getNowTime() {
    // 오늘 날짜
    return DateFormat("yyyyMMdd").format(now);
  }

  String getYesterdayDate() {
    // 어제 날짜
    return DateFormat("yyyyMMdd").format(
        DateTime.now().subtract(Duration(days: 1)));
  }

  void getLocacion() async {

  }
  Future<void> getWeather() async {
    await _myLocation.updateLocation();
    xCoordinate = _myLocation.getX();  //x좌표
    yCoordinate = _myLocation.getY();  //y좌표

    Lati = _myLocation.getlongi(); // 현재위치 기반 위도
    Longi = _myLocation.getlate();
    //위도 경도로 현재 행정위치 찾기
    var kakaoXYUrl = Uri.parse('https://dapi.kakao.com/v2/local/geo/coord2regioncode.json?'
        'input_coord=WGS84&output_coord=WGS84&x=$Lati&y=$Longi');
    var kakaoTM = await http.get(kakaoXYUrl, headers: {"Authorization": "KakaoAK $kakaoApiKey"});
    var TM = jsonDecode(kakaoTM.body);
    /*print(_myLocation.getX());
    print(_myLocation.getlongi());
    print(_myLocation.getlate());*/
    nowlocate = TM['documents'][0]['region_2depth_name'];
    //nowlocate = TM;

    shortWeatherDate();
    //기상청 api 호출
    var url = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?'
        'serviceKey=$weatherApiKey&numOfRows=290&pageNo=1&'
        'base_date=$baseDate&base_time=$baseTime&nx=$xCoordinate&ny=$yCoordinate&dataType=JSON';

    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> nowWeather = jsonDecode(response.body);
    List<dynamic> itemList = nowWeather['response']['body']['items']['item'];



  void Parsing2() {
    int count=0;
    // 0000시 기준의 예보 데이터 추출
    for (dynamic item in itemList) {
      /*if (item['category'] == 'TMP') {
        TMPdata.add({
          'fcstTime': item['fcstTime'],
          'category': item['category'],
          'fcstValue': item['fcstValue'],
        });
      }
      if (item['category'] == 'POP') {
        POPdata.add({
          'fcstTime': item['fcstTime'],
          'category': item['category'],
          'fcstValue': item['fcstValue'],
        });
      }
      if (item['category'] == 'POP') {
        Popdata2.add({
          'fcstValue': item['fcstValue'],
        });
      }*/
      if (item['category'] == 'TMP') {
        TMPdata[count] = item['fcstValue'];
        count++;
      }
    }

  }
    Parsing2();
    print(nowWeather);
    print("afs");

  }
  void shortWeatherDate(){
    baseDate = getYesterdayDate();   //어제 날짜
    baseTime = "2300";
  }

  String? getNowlocate(){
    return nowlocate;
  }

  int getTMP(hour){
    return TMPdata[hour];
  }

  int getPOP(hour){
    return Popdata[hour];
  }
 // String? getNowWeather(){
  //  return nowWeather;
 // }



}