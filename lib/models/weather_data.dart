class WeatherData {
  final String city;
  final double temperatureCelsius;
  final String description;
  final int humidity;
  final double windSpeed;
  final String icon;

  WeatherData({
    required this.city,
    required this.temperatureCelsius,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
  });

  factory WeatherData.fromJson(Map<String, dynamic>? json) {
    if (json == null) throw Exception('Invalid weather data');

    try {
      final city = json['city']?.toString() ?? 'Unknown';
      final temperature = json['temperature'] ?? json['temperatureCelsius'];
      final description = json['description']?.toString() ?? 'No description';
      final humidity = json['humidity'];
      final windSpeed = json['windSpeed'];
      final icon = json['icon']?.toString() ?? '❓';

      // ✅ Parse temperature
      double tempValue;
      if (temperature == null) {
        tempValue = 0.0;
      } else if (temperature is num) {
        tempValue = temperature.toDouble();
      } else if (temperature is String &&
          double.tryParse(temperature) != null) {
        tempValue = double.parse(temperature);
      } else {
        throw Exception('Invalid temperature type');
      }

      // ✅ Parse humidity
      int humidityValue;
      if (humidity == null) {
        humidityValue = 0;
      } else if (humidity is num) {
        humidityValue = humidity.toInt();
      } else if (humidity is String && int.tryParse(humidity) != null) {
        humidityValue = int.parse(humidity);
      } else {
        throw Exception('Invalid humidity type');
      }

      // ✅ Parse wind speed
      double windSpeedValue;
      if (windSpeed == null) {
        windSpeedValue = 0.0;
      } else if (windSpeed is num) {
        windSpeedValue = windSpeed.toDouble();
      } else if (windSpeed is String && double.tryParse(windSpeed) != null) {
        windSpeedValue = double.parse(windSpeed);
      } else {
        windSpeedValue = 0.0; // fallback
      }

      return WeatherData(
        city: city,
        temperatureCelsius: tempValue,
        description: description,
        humidity: humidityValue,
        windSpeed: windSpeedValue,
        icon: icon,
      );
    } catch (e) {
      throw Exception('Failed to parse weather data: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'temperature': temperatureCelsius,
    'description': description,
    'humidity': humidity,
    'windSpeed': windSpeed,
    'icon': icon,
  };
}
