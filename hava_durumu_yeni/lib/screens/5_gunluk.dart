import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';
import 'homeScreen.dart';

class ForecastPage extends StatefulWidget {
  final String cityName;

  ForecastPage({required this.cityName});

  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  late Future<List<dynamic>> forecast;

  Map<String, String> weatherTranslations = {
    "Clear": "Açık",
    "Rain": "Yağmurlu",
    "Snow": "Karlı",
    "Clouds": "Bulutlu",
    "Mist": "Sisli",
    "Shower Rain": "Sağanak Yağış",
    "Thunderstorm": "Gökgürültülü Fırtına",
    "Broken Clouds": "Parçalı bulutlu",
    "Scattered Clouds": "Az Bulutlu", // Corrected from Scattered Cloud
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
    "Clear": WeatherIcons.day_sunny,
    "Rain": WeatherIcons.rain,
    "Snow": WeatherIcons.snow,
    "Clouds": WeatherIcons.cloudy,
    "Mist": WeatherIcons.fog,
    "Shower Rain": WeatherIcons.showers,
    "Thunderstorm": WeatherIcons.thunderstorm,
    "Broken Clouds": WeatherIcons.cloudy,
    "Scattered Clouds":
        WeatherIcons.day_cloudy, // Corrected from Scattered Cloud
  };

  Future<List<dynamic>> fetchForecast(String cityName) async {
    final resp = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=46f80a02ecae410460d59960ded6e1c6&units=metric"));

    if (resp.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(resp.body);
      return json['list'] as List<dynamic>;
    } else {
      throw Exception('Failed to load forecast');
    }
  }

  @override
  void initState() {
    super.initState();
    forecast = fetchForecast(widget.cityName);
  }

  String formatDate(String dtTxt) {
    final dt = DateTime.parse(dtTxt);
    return DateFormat('dd/MM/yyyy').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 125, 152, 173),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 50, 129, 194),
        title: Text('${widget.cityName} için 5 Günlük Tahmin'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: forecast,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var uniqueDates = <String>{}; // Unique dates are stored in this set
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var forecastDay = snapshot.data![index];
                String formattedDate = formatDate(forecastDay['dt_txt']);
                bool isUniqueDate = uniqueDates.add(formattedDate);

                String weatherMain = forecastDay['weather'][0]['main'];
                String weatherDesc =
                    weatherTranslations[weatherMain] ?? 'Bilinmiyor';
                IconData weatherIcon =
                    weatherIcons[weatherMain] ?? WeatherIcons.na;

                // Sıcaklık, nem ve rüzgar hızı değerlerini al ve tam sayıya dönüştür
                int temperature = forecastDay['main']['temp'].toInt();
                int humidity = forecastDay['main']['humidity'];
                int windSpeed = forecastDay['wind']['speed'].toInt();

                return isUniqueDate
                    ? ListTile(
                        leading: Icon(
                          weatherIcon,
                          color: weatherColors[weatherMain] ?? Colors.white,
                        ),
                        title: Text('Sıcaklık: $temperature°C'),
                        subtitle:
                            Text('Nem: $humidity% Rüzgar: ${windSpeed}m/s'),
                        trailing: Text(formattedDate),
                      )
                    : SizedBox.shrink();
              },
            );
          } else if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
