import 'package:flutter/material.dart';
import 'package:wear_today/data_API/location.dart';
import 'package:wear_today/main.dart';
import 'package:wear_today/data_API/weatherData.dart';


class mainPage extends StatefulWidget{
  final MyLocation myLocation;
  final weatherData weather;
  mainPage({Key? key, required this.myLocation, required this.weather}) : super(key: key);
  @override
  State<StatefulWidget> createState(){
    return _mainPage();
  }
}

class _mainPage extends State<mainPage>{
  @override
  void initState(){
    super.initState();
    widget.myLocation.updateLocation().then((_) {
      setState(() {
        widget.weather.getWeather().then((_){
          setState(() {

          });
        });
      });
    });

  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 75,
            ),
            //Text('${widget.myLocation.getX()}°',style: TextStyle(fontSize: 150,fontWeight: FontWeight.bold),),
            //Text('y좌표 : ${widget.myLocation.getY()}'),
            Icon(Icons.location_on),
            Text('${widget.weather.getNowlocate()}',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            //Text(widget.weather.getNowWeather()),
          ],
        ),
      ),
    );
  }
}