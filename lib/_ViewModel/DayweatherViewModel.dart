import 'package:flutter/material.dart';
import '../_Model/weatherModel.dart';
import '../_Repository/DayWeatherRepo.dart';

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
    notifyListeners();
  }


}