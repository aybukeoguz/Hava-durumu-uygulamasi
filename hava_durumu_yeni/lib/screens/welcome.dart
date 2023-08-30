import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weatherapp/screens/homeScreen.dart';
import 'package:weather_animation/weather_animation.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 3)).then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade200,
      
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(),
        child: Container(
          width: MediaQuery.of(context).size.width, 
          height: MediaQuery.of(context).size.height, 
          child: WeatherScene.weatherEvery.getWeather(),
        ),
        
      ),
    );
  }
}
