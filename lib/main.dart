import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wear_today/_ViewModel/DayweatherViewModel.dart';
import 'package:wear_today/_View/MainPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

void main() async{
  //WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase 초기화
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // 앱 세로 고정
    return MaterialApp(
      home: ChangeNotifierProvider<DayWeatherViewModel>( // ViewModel을 구독함으로써 데이터 변경 시 모든 위젯 새로고침.
        create: (context) => DayWeatherViewModel(),
        child: const MainView(),
      ),
    );
  }
}