import 'package:flutter/material.dart';
import '../_Model/weatherModel.dart';
import '../_Repository/DayWeatherRepo.dart';
import 'package:wear_today/_Model/global.dart';

//View의 상태를 관리하고 View의 비즈니스 로직을 담당
//notifyListeners를 통해 데이터에 업데이트가 있다는 것을 ViewModel를 참조하고 있는 View에게 알려줌.

class DayWeatherViewModel with ChangeNotifier {
  late final DayWeatherRepository _dayWeatherRepository;
  List<DayWeather> _weatherList = List.empty(growable: true);
  List<DayWeather> get weatherList => _weatherList;

  DayWeatherViewModel(){
    _dayWeatherRepository = DayWeatherRepository();
    _getWeatherList();
  }

  Future<void> _getWeatherList() async{
    _weatherList = await _dayWeatherRepository.getWeatherList();
    print(_weatherList);
    notifyListeners(); // 구독하고 있는 위젯들이 갱신됨. main함수 MaterialApp에서 구독하고 있으므로 하위 위젯들이 모두 갱신됨.
  }

  Future<void> refreshWeatherList() async{
    _weatherList = [];
    await _getWeatherList();
  }
}