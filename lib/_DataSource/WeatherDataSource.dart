import 'dart:convert';
import 'package:http/http.dart' as http;
import '../_Model/weatherModel.dart';
import 'package:wear_today/_DataSource/location.dart';
import 'package:intl/intl.dart';
import '../_DataSource/global.dart';

class WeatherDataSource {
  final MyLocation _myLocation = MyLocation();

  var now = DateTime.now();
  String? baseTime; // 기준 시간
  String? baseDate; // 기준 날짜
  int? xCoordinate; // 변환된 x좌표
  int? yCoordinate; // 변환된 y좌표
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

  Future<List<DayWeather>> getWeatherList() async {
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
    print(_myLocation.getX());
    print(_myLocation.getlongi());
    print(_myLocation.getlate());
    nowlocate = TM['documents'][0]['region_2depth_name'];
    //nowlocate = TM;

    shortWeatherDate();
    //기상청 api 호출
    var url = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?'
        'serviceKey=$weatherApiKey&numOfRows=290&pageNo=1&'
        'base_date=$baseDate&base_time=$baseTime&nx=$xCoordinate&ny=$yCoordinate&dataType=JSON';

    final response = await http.get(Uri.parse(url));
    //Map<String, dynamic> nowWeather = jsonDecode(response.body);
    return jsonDecode(response.body)['response']['body']['items']['item'].map<DayWeather>((json) => DayWeather.fromJson(json)).toList();





  }
}