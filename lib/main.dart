import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wear_today/_ViewModel/DayweatherViewModel.dart';
import 'package:wear_today/_View/MainPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:wear_today/_ViewModel/DBViewModel.dart';

import '_DataSource/DBHelper.dart';

void main() async{
  //WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase 초기화
  //await DBHelper.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<DayWeatherViewModel>(
            create: (context) => DayWeatherViewModel(),
          ),
          ChangeNotifierProvider<DBViewModel>(
            create: (context) => DBViewModel(),
          ),
          // 추가적인 ViewModel을 등록할 수 있음
        ],
        child: const MainView(),
      ),
    );
  }
}