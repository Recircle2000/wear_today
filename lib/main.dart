import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wear_today/_ViewModel/DayweatherViewModel.dart';
import 'package:wear_today/_View/MainPage.dart';
import 'package:firebase_core/firebase_core.dart';

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
    return MaterialApp(
      home: ChangeNotifierProvider<DayWeatherViewModel>(
        create: (context) => DayWeatherViewModel(),
        child: const MainView(),
      ),
    );
  }
}