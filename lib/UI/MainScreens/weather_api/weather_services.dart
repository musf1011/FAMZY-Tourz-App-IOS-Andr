// lib/UI/MainScreens/weather/open_meteo_service.dart
import 'dart:convert';
import 'package:famzy_tourz_app/UI/MainScreens/weather_api/open_meteo_model.dart';
import 'package:http/http.dart' as http;
// import 'open_meteo_model.dart';

class OpenMeteoService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<WeatherData> getWeather(double latitude, double longitude) async {
    final response = await http
        .get(Uri.parse('$_baseUrl?latitude=$latitude&longitude=$longitude'
            '&hourly=temperature_2m,precipitation,uv_index'
            '&daily=sunrise,sunset'
            '&timezone=auto'));

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}






// // lib/UI/MainScreens/weather/open_meteo_model.dart
// import 'package:json_annotation/json_annotation.dart';

// part 'open_meteo_model.g.dart';

// @JsonSerializable()
// class WeatherData {
//   final HourlyData hourly;
//   final DailyData daily;

//   WeatherData({required this.hourly, required this.daily});

//   factory WeatherData.fromJson(Map<String, dynamic> json) =>
//       _$WeatherDataFromJson(json);
// }

// @JsonSerializable()
// class HourlyData {
//   final List<String> time;
//   @JsonKey(name: 'temperature_2m')
//   final List<double> temperature;
//   @JsonKey(name: 'precipitation')
//   final List<double> rain;
//   @JsonKey(name: 'uv_index')
//   final List<double> uvIndex;

//   HourlyData({
//     required this.time,
//     required this.temperature,
//     required this.rain,
//     required this.uvIndex,
//   });

//   factory HourlyData.fromJson(Map<String, dynamic> json) =>
//       _$HourlyDataFromJson(json);
// }

// @JsonSerializable()
// class DailyData {
//   final List<String> sunrise;
//   final List<String> sunset;

//   DailyData({required this.sunrise, required this.sunset});

//   factory DailyData.fromJson(Map<String, dynamic> json) =>
//       _$DailyDataFromJson(json);
// // }

// import 'package:json_annotation/json_annotation.dart';
// part 'weather_model.g.dart';

// @JsonSerializable(explicitToJson: true)
// class WeatherData {
//   final HourlyData hourly;
//   final DailyData daily;

//   WeatherData({required this.hourly, required this.daily});

//   factory WeatherData.fromJson(Map<String, dynamic> json) =>
//       _$WeatherDataFromJson(json);

//   Map<String, dynamic> toJson() => _$WeatherDataToJson(this); // Add this
// }

// @JsonSerializable()
// class HourlyData {
//   @JsonKey(name: 'time')
//   final List<String> time;
//   @JsonKey(name: 'temperature_2m')
//   final List<double> temperature;
//   @JsonKey(name: 'precipitation')
//   final List<double> rain;
//   @JsonKey(name: 'uv_index')
//   final List<double> uvIndex;

//   HourlyData({
//     required this.time,
//     required this.temperature,
//     required this.rain,
//     required this.uvIndex,
//   });

//   factory HourlyData.fromJson(Map<String, dynamic> json) =>
//       _$HourlyDataFromJson(json);

//   Map<String, dynamic> toJson() => _$HourlyDataToJson(this); // Add this
// }

// @JsonSerializable()
// class DailyData {
//   @JsonKey(name: 'sunrise')
//   final List<String> sunrise;
//   final List<String> sunset;

//   DailyData({required this.sunrise, required this.sunset});

//   factory DailyData.fromJson(Map<String, dynamic> json) =>
//       _$DailyDataFromJson(json);

//   Map<String, dynamic> toJson() => _$DailyDataToJson(this); // Add this
// }
