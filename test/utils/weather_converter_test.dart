import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/utils/weather_converter.dart';

void main() {
  group('🌡️ WeatherConverter Tests', () {
    test('✅ Converts Celsius to Fahrenheit', () {
      expect(WeatherConverter.celsiusToFahrenheit(0), 32);
      expect(WeatherConverter.celsiusToFahrenheit(25), closeTo(77, 0.1));
      expect(WeatherConverter.celsiusToFahrenheit(-40), -40);
    });

    test('✅ Converts Fahrenheit to Celsius', () {
      expect(WeatherConverter.fahrenheitToCelsius(32), 0);
      expect(WeatherConverter.fahrenheitToCelsius(77), closeTo(25, 0.1));
      expect(WeatherConverter.fahrenheitToCelsius(-40), -40);
    });
  });
}
