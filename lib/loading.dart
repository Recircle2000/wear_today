import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wear_today/mainPage.dart';
import 'package:wear_today/data_API/location.dart';

class Loading extends StatefulWidget {

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late Position _position;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _position = position;
    });
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    // 추적이 완료되면 다음 화면으로 이동하는 코드
    //Navigator.pushReplacement(
      //context
      //MaterialPageRoute(builder: (context) => mainPage(myLocation: myLocation, weather: weather)),
    //);
  }

  @override
  Widget build(BuildContext context) {
    // 위치 추적 중에 보여줄 UI 코드
    if (_position == null) {
      return Center(
          child: Text('오늘 뭐입지?', style: TextStyle(fontSize: 40),) );
    }

    // 위치 추적이 완료되면 이동할 화면으로 이동하는 코드
    _navigateToNextScreen();

    // 위치 추적이 완료되면 다른 UI 코드는 불필요하므로 빈 컨테이너를 반환합니다.
    return Container();
  }
}

