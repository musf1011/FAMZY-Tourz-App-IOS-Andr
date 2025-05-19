// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_meteo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) => WeatherData(
      hourly: HourlyData.fromJson(json['hourly'] as Map<String, dynamic>),
      daily: DailyData.fromJson(json['daily'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherDataToJson(WeatherData instance) =>
    <String, dynamic>{
      'hourly': instance.hourly,
      'daily': instance.daily,
    };

HourlyData _$HourlyDataFromJson(Map<String, dynamic> json) => HourlyData(
      time: (json['time'] as List<dynamic>).map((e) => e as String).toList(),
      temperature: (json['temperature_2m'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      rain: (json['precipitation'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      uvIndex: (json['uv_index'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$HourlyDataToJson(HourlyData instance) =>
    <String, dynamic>{
      'time': instance.time,
      'temperature_2m': instance.temperature,
      'precipitation': instance.rain,
      'uv_index': instance.uvIndex,
    };

DailyData _$DailyDataFromJson(Map<String, dynamic> json) => DailyData(
      sunrise:
          (json['sunrise'] as List<dynamic>).map((e) => e as String).toList(),
      sunset:
          (json['sunset'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DailyDataToJson(DailyData instance) => <String, dynamic>{
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
    };
