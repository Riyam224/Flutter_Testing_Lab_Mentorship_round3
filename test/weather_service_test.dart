import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/services/weather_service.dart';

void main() {
  final service = WeatherService();
  group('🌤️ WeatherService Tests', () {
    test('✅ fetchWeather returns valid data for known city', () async {
      final result = await service.fetchWeather('London');
      expect(result, isNotNull);
      expect(result!.city, 'London');
    });

    test('⚠️ fetchWeather returns null for invalid city', () async {
      try {
        final result = await service.fetchWeather('');
        expect(result, isNull);
      } catch (e) {
        fail('fetchWeather should handle null safely, not throw.');
      }
    });
  });
}
