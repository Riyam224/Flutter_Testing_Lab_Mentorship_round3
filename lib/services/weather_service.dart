import 'dart:async';
import '../models/weather_data.dart';

class WeatherService {
  /// Simulated weather API request
  Future<WeatherData?> fetchWeather(String city) async {
    await Future.delayed(const Duration(seconds: 2));

    final normalizedCity = city.trim();
    final lowerCity = normalizedCity.toLowerCase();
    if (normalizedCity.isEmpty || lowerCity == 'invalid city') return null;

    try {
      // Randomly simulate incomplete API response
      if (DateTime.now().millisecond % 4 == 0) {
        return WeatherData.fromJson({
          'city': normalizedCity,
          'temperature': 22.5,
        });
      }

      final Map<String, dynamic> data = {
        'city': normalizedCity,
        'temperature': _getTemperature(lowerCity),
        'description': _getDescription(lowerCity),
        'humidity': _getHumidity(lowerCity),
        'windSpeed': _getWindSpeed(lowerCity),
        'icon': _getIcon(lowerCity),
      };

      // Ensure all keys have valid types before passing to model
      if (data.values.any((v) => v == null)) return null;

      return WeatherData.fromJson(data);
    } catch (e) {
      // Return null safely instead of throwing
      return null;
    }
  }

  double _getTemperature(String city) {
    switch (city) {
      case 'london':
        return 15.0;
      case 'tokyo':
        return 25.0;
      case 'cairo':
        return 30.0;
      case 'baghdad':
        return 35.0;
      default:
        return 22.5;
    }
  }

  String _getDescription(String city) {
    switch (city) {
      case 'london':
        return 'Rainy';
      case 'tokyo':
        return 'Cloudy';
      case 'cairo':
        return 'Sunny';
      case 'baghdad':
        return 'Hot';
      default:
        return 'Sunny';
    }
  }

  int _getHumidity(String city) {
    switch (city) {
      case 'london':
        return 85;
      case 'tokyo':
        return 70;
      case 'cairo':
        return 50;
      case 'baghdad':
        return 40;
      default:
        return 65;
    }
  }

  double _getWindSpeed(String city) {
    switch (city) {
      case 'london':
        return 8.5;
      case 'tokyo':
        return 5.2;
      case 'cairo':
        return 10.0;
      case 'baghdad':
        return 7.5;
      default:
        return 12.3;
    }
  }

  String _getIcon(String city) {
    switch (city) {
      case 'london':
        return '🌧️';
      case 'tokyo':
        return '☁️';
      case 'cairo':
        return '☀️';
      case 'baghdad':
        return '🔥';
      default:
        return '☀️';
    }
  }
}
