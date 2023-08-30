import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_icons/weather_icons.dart';
import '5_gunluk.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Weather> fetchWeather(String cityName) async {
    final resp = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=46f80a02ecae410460d59960ded6e1c6&units=metric"));

    if (resp.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(resp.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Şehir ismi aratınız!');
    }
  }

  late Future<Weather> myWeather;
  TextEditingController cityController = TextEditingController();
  late Color backgroungColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myWeather = fetchWeather('Antalya');
  }

  Map<String, String> weatherTranslations = {
    "Clear": "Açık",
    "Rain": "Yağmurlu",
    "Snow": "Karlı",
    "Clouds": "Bulutlu",
    "Mist": "Sisli",
    "Shower Rain": "Sağanak Yağış",
    "Thunderstorm": "Gökgürültülü Fırtına",
    "Broken Clouds": "Parçalı bulutlu",
    "Scattered Cloud": "Az Bulutlu",
  };
  Map<String, Color> weatherColors = {
    "Clear": Colors.yellow,
    "Rain": Colors.white,
    "Snow": Colors.white,
    "Clouds": Colors.white,
    "Mist": Colors.grey,
    "Shower Rain": Colors.white,
    "Thunderstorm": Colors.grey,
    "Broken Clouds": Colors.white30,
    "Scattered Cloud": Colors.white30


  };
  Map<String, IconData> weatherIcons = {
    "Clear": Icons.sunny,
    "Rain": WeatherIcons.rain,
    "Clouds": WeatherIcons.cloudy,
    "Snow": WeatherIcons.snow,
    "Mist": WeatherIcons.fog,
    "Shower Rain": WeatherIcons.showers,
    "Thunderstorm": WeatherIcons.thunderstorm,
    "Broken Clouds": WeatherIcons.day_cloudy,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 50, 129, 194),
        title: Text('Weather App'),
      ),
      backgroundColor: Color.fromARGB(255, 125, 152, 173),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 40.0,
          right: 15.0,
          top: 30.0,
        ),
        child: Column(children: [
          SafeArea(
            top: true,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextField(
                          controller: cityController,
                          decoration: InputDecoration(
                            hintText: 'Şehir ismi girin',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          myWeather = fetchWeather(cityController.text);
                        });
                      },
                      child:
                          Text('Getir', style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                FutureBuilder<Weather>(
                  future: myWeather,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            snapshot.data!.name.split(' ')[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            weatherTranslations[snapshot.data!.weather[0]
                                    ['main']]
                                .toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                letterSpacing: 1.3,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '${DateFormat('dd/MM/yyyy \n\t\t   HH:mm').format(DateTime.now())}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FutureBuilder<Weather>(
                            future: myWeather,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                IconData? weatherIcon = weatherIcons[
                                    snapshot.data!.weather[0]['main']];
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (weatherIcon != null)
                                      Icon(
                                        weatherIcon,
                                        color: weatherColors[snapshot
                                            .data!.weather[0]['main']
                                            .toString()],
                                        size: 100,
                                      )
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Text('Hata: ${snapshot.error}');
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                          const SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'Sıcaklık',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${((snapshot.data!.main['temp'].toStringAsFixed(0)))}°',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Rüzgar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${snapshot.data!.wind['speed']} km/h',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'Nem',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '%${snapshot.data!.main['humidity']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Column(
                            children: [
                              const Text(
                                'Hissedilen Sıcaklık ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                '${snapshot.data!.main['feels_like']}°',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return const Text('');
                    } else {
                      return CircularProgressIndicator(
                        color: Colors.white,
                      );
                    }
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ForecastPage(cityName: cityController.text),
                          ),
                        );
                      },
                      child: Text(
                        '5 Günlük Tahmin',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
