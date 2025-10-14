import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/models/weather_data.dart';

void main() {
  group('🌦️ WeatherData Model Tests', () {
    test("✅ fromJson parses valid data correctly", () {
      final json = {
        'city': 'London',
        'temperature': 15.0,
        'description': 'Rainy',
        'humidity': 80,
        'windSpeed': 10.5,
        'icon': '🌧️',
      };
      final data = WeatherData.fromJson(json);
      expect(data.city, 'London');
      expect(data.temperatureCelsius, 15.0);
      expect(data.description, 'Rainy');
      expect(data.humidity, 80);
      expect(data.windSpeed, 10.5);
      expect(data.icon, '🌧️');
    });

    test('✅ fromJson assigns defaults for missing fields', () {
      final json = {'city': 'Paris'};
      final data = WeatherData.fromJson(json);

      expect(data.temperatureCelsius, 0);
      expect(data.description, 'No description');
      expect(data.humidity, 0);
      expect(data.windSpeed, 0);
      expect(data.icon, '❓');
    });

    test("❌ fromJson throws exception for invalid data -null input", () {
      expect(() => WeatherData.fromJson(null), throwsException);
    });
  });
}
