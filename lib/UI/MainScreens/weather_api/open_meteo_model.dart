// created by FAMZY CodeWorks
import 'package:json_annotation/json_annotation.dart';

part 'open_meteo_model.g.dart';

@JsonSerializable()
class WeatherData {
  final HourlyData hourly;
  final DailyData daily;

  WeatherData({required this.hourly, required this.daily});

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);
}

@JsonSerializable()
class HourlyData {
  final List<String> time;
  @JsonKey(name: 'temperature_2m')
  final List<double> temperature;
  @JsonKey(name: 'precipitation')
  final List<double> rain;
  @JsonKey(name: 'uv_index')
  final List<double> uvIndex;

  HourlyData({
    required this.time,
    required this.temperature,
    required this.rain,
    required this.uvIndex,
  });

  factory HourlyData.fromJson(Map<String, dynamic> json) =>
      _$HourlyDataFromJson(json);
}

@JsonSerializable()
class DailyData {
  final List<String> sunrise;
  final List<String> sunset;

  DailyData({required this.sunrise, required this.sunset});

  factory DailyData.fromJson(Map<String, dynamic> json) =>
      _$DailyDataFromJson(json);
}
