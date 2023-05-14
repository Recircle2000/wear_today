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
  var now = DateTime.now();
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

            Icon(Icons.location_on),
            Text('${widget.weather.getNowlocate()}',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
            Text('${now.hour}시 기준',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            Text('${widget.weather.TMPdata2[now.hour]}°',style: TextStyle(fontSize: 120,fontWeight: FontWeight.bold),),
            //Text('${now.hour}',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
            //Text('y좌표 : ${widget.myLocation.getY()}',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
            //Text(widget.weather.getNowWeather()),
          ],
        ),
      ),
    );
  }
}