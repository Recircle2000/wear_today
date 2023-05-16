//JSON데이터를 DayWeather 클래스 리스트로 저장. 이 과정에서 우리가 원하는 값(

class DayWeather{
  int? fcstDate; // 예보일자
  String? fcstTime; // 예보시각
  String? category; // 자료구분문자
  double? fcstValue; // 예보 값

  DayWeather({this.category,this.fcstDate,this.fcstTime,this.fcstValue});
  //Json데이터를 포함한 맵을 DataSource에서 받아옴.
  factory DayWeather.fromJson(Map<String, dynamic> json) {
    return DayWeather(
        fcstDate: int.tryParse(json['fcstDate']),
        fcstTime: json['fcstTime'],
        category: json['category'],
        fcstValue: double.tryParse(json['fcstValue']));
  }//받아온 값을 사용하여 DayWeather객체 생성 후 반환.
}