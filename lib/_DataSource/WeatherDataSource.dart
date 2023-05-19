import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../_Model/weatherModel.dart';
import 'package:wear_today/_DataSource/location.dart';
import 'package:intl/intl.dart';
import '../_Model/global.dart';


class WeatherDataSource {
  final MyLocation _myLocation = MyLocation();

  var now = DateTime.now();
  String? baseTime; // 기준 시간
  String? baseDate; // 기준 날짜
  double? xCoordinate; // 변환된 x좌표
  double? yCoordinate; // 변환된 y좌표
  double? Lati; // 위도
  double? Longi; // 경도

  String weatherApiKey = 'kSkqn5bgn8LgTC9jUY%2BCGqqcdIzVhyNl43a%2BbSfbU1QHu%2FrkFnB4Bc4b%2FEcdgltpoLhNfn3zSabBQJFmPGY13Q%3D%3D';
  String kakaoApiKey = '6a44b3f5c4022f698187e22c435f4fa5';


  String getNowTime() {
    // 오늘 날짜
    return DateFormat("yyyyMMdd").format(now);
  }

  String getYesterdayDate() {
    // 어제 날짜
    return DateFormat("yyyyMMdd").format(
        DateTime.now().subtract(Duration(days: 1)));
  }

  void shortWeatherDate(){
    baseDate = getYesterdayDate();   //어제 날짜
    baseTime = "2300";
  }

  Future<int> searchXYlocation(String updateLocate) async {
    var kakaoXYUrl = Uri.parse('https://dapi.kakao.com/v2/local/search/address.json?analyze_type=similar&page=1&size=10&query=$updateLocate');
    var kakaoTM = await http.get(kakaoXYUrl, headers: {"Authorization": "KakaoAK $kakaoApiKey"});
    var TM = jsonDecode(kakaoTM.body);
    Longi = double.parse(TM['documents'][0]['address']['x']);
    Lati = double.parse(TM['documents'][0]['address']['y']);
    _myLocation.lolaTOxy(Longi!, Lati!);
    xCoordinate = _myLocation.getX();  //x좌표
    yCoordinate = _myLocation.getY(); //y좌표
    return 0;
  }

  void getXY2lalo() async{
    var kakaoXYUrl = Uri.parse('https://dapi.kakao.com/v2/local/geo/coord2regioncode.json?'
        'input_coord=WGS84&output_coord=WGS84&x=$Lati&y=$Longi');
    var kakaoTM = await http.get(kakaoXYUrl, headers: {"Authorization": "KakaoAK $kakaoApiKey"});
    var TM = jsonDecode(kakaoTM.body);
    /*print(_myLocation.getX());
    print(_myLocation.getlongi());
    print(_myLocation.getlate());*/
    nowLocate = TM['documents'][0]['region_2depth_name']; // 현재 위치를 global 전역 변수에 저장.
    islocate = Icons.location_on;
  }

  Future<List<DayWeather>> getWeatherList() async {
    if (nowLocate == '위치 수신 중..') {
      await _myLocation.updateLocation();
      xCoordinate = _myLocation.getX();  //x좌표
      yCoordinate = _myLocation.getY(); //y좌표
      Lati = _myLocation.getlongi(); // 현재위치 기반 위도
      Longi = _myLocation.getlate();
      //위도 경도로 현재 행정위치 찾기
      getXY2lalo();
    } else if (nowLocate != updateLocate) {
      await searchXYlocation(updateLocate!);
    }
    shortWeatherDate(); // 어제 날짜랑 기준 날짜를 저장.
    //기상청 api 호출

    var url = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?'
        'serviceKey=$weatherApiKey&numOfRows=290&pageNo=1&'
        'base_date=$baseDate&base_time=$baseTime&nx=${xCoordinate?.toInt()}&ny=${yCoordinate?.toInt()}&dataType=JSON';
    // 어제 23시를 기준으로 오늘 예보를 불러옴.
    final response = await http.get(Uri.parse(url));
    //Map<String, dynamic> nowWeather = jsonDecode(response.body);
    return jsonDecode(response.body)['response']['body']['items']['item'] // 가져온 원본 JSON에서 item키 까지 추출하고 JSON 디코딩.
        .map<DayWeather>((json) => DayWeather
        .fromJson(json))// 반환된 객체에 map메서드를 호출하여 Model의 DayWeather객체로 변환.
        .toList(); //객체를 리스트로 변환.
  }
}