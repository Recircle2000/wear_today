import '../_DataSource/location.dart';
import '../_DataSource/WeatherDataSource.dart';
import '../_Model/weatherModel.dart';
import '../_Repository/DayWeatherRepo.dart';
import '../_ViewModel/DayweatherViewModel.dart';
import '../_View/MainPage.dart';

// 그냥 전역 변수 저장하는 곳.

String? nowlocate = '위치 수신 중..'; //현재 위치, View_Mainpage에서 사용.