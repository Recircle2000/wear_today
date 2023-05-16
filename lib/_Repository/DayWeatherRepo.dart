import '../_DataSource/WeatherDataSource.dart';
import '../_Model/weatherModel.dart';
//DataSource에 접근

class DayWeatherRepository {
  final WeatherDataSource _weatherDataSource = WeatherDataSource();

  Future<List<DayWeather>> getWeatherList(){
    return _weatherDataSource.getWeatherList();
  }


}