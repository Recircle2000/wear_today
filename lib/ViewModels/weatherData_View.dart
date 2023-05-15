import 'package:wear_today/data_API/weatherData.dart';

String weatherApiKey = 'kSkqn5bgn8LgTC9jUY%2BCGqqcdIzVhyNl43a%2BbSfbU1QHu%2FrkFnB4Bc4b%2FEcdgltpoLhNfn3zSabBQJFmPGY13Q%3D%3D';
String kakaoApiKey = '3e56753d80fccbe6381d50ef7b784d30';
List Popdata = [];
List TMPdata = List.filled(24, 0); //온도 데이터
List SKYdata = List.filled(24,0); //구름 상태
List PTYdata = List.filled(24,0); //강수 형태
int TMN = 0; //최저기온
int IMX = 0; //최고기온
//List<Map<String, dynamic>> TMPdata = [];
//List<Map<String, dynamic>> POPdata = [];

class weatherdata_ViewModel() {

}
