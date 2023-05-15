class DayWeather{
  int? fcstDate; // 예보일자
  String? fcstTime; // 예보시각
  String? category; // 자료구분문자
  double? fcstValue; // 예보 값

  DayWeather({this.category,this.fcstDate,this.fcstTime,this.fcstValue});

  factory DayWeather.fromJson(Map<String, dynamic> json) {
    return DayWeather(fcstDate: int.tryParse(json['fcstDate']),fcstTime: json['fcstTime'],category: json['category'],fcstValue: double.tryParse(json['fcstValue']));
  }
}