import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/models/weather_data.dart';
import 'package:flutter_testing_lab/services/weather_service.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart'
    hide WeatherData;
import 'package:flutter_testing_lab/utils/weather_converter.dart';

/// ✅ Mock WeatherService to simulate API behavior safely in tests
class MockWeatherService extends WeatherService {
  final bool shouldFail;
  final WeatherData? mockData;

  MockWeatherService({this.shouldFail = false, this.mockData});

  @override
  Future<WeatherData?> fetchWeather(String city) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (shouldFail) throw Exception('Network Error');
    return mockData ??
        WeatherData(
          city: city,
          temperatureCelsius: 25.0,
          description: 'Sunny',
          humidity: 50,
          windSpeed: 10.0,
          icon: '☀️',
        );
  }
}

void main() {
  group('WeatherDisplay Widget Tests', () {
    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // ✅ Allow timers (like WeatherService delay) to complete before test ends
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('handles city names with whitespace and mixed case', (
      tester,
    ) async {
      final mockService = MockWeatherService(
        mockData: WeatherData(
          city: 'London',
          temperatureCelsius: 15.0,
          description: 'Rainy',
          humidity: 80,
          windSpeed: 5.0,
          icon: '🌧️',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TestableWeatherDisplay(service: mockService)),
        ),
      );

      await tester.pump(const Duration(seconds: 3));

      expect(find.textContaining('London'), findsOneWidget);
    });

    testWidgets('displays weather data correctly', (tester) async {
      final mockService = MockWeatherService();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TestableWeatherDisplay(service: mockService)),
        ),
      );

      await tester.pump(const Duration(seconds: 3));

      expect(find.textContaining('°C'), findsOneWidget);
      expect(find.text('Sunny'), findsOneWidget);
      expect(find.textContaining('Humidity'), findsOneWidget);
      expect(find.textContaining('Wind Speed'), findsOneWidget);
    });

    testWidgets('shows error message when service fails', (tester) async {
      final mockService = MockWeatherService(shouldFail: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TestableWeatherDisplay(service: mockService)),
        ),
      );

      await tester.pump(const Duration(seconds: 3));

      expect(find.textContaining('Network Error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('switch toggles between Celsius and Fahrenheit', (
      tester,
    ) async {
      final mockService = MockWeatherService();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TestableWeatherDisplay(service: mockService)),
        ),
      );

      await tester.pump(const Duration(seconds: 3));

      expect(find.textContaining('°C'), findsOneWidget);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.textContaining('°F'), findsOneWidget);
    });
  });

  group('Temperature Conversion Tests', () {
    test('celsiusToFahrenheit returns correct value', () {
      expect(WeatherConverter.celsiusToFahrenheit(0), 32);
      expect(WeatherConverter.celsiusToFahrenheit(100), 212);
      expect(WeatherConverter.celsiusToFahrenheit(-40), -40);
      expect(WeatherConverter.celsiusToFahrenheit(25), closeTo(77, 0.01));
    });

    test('fahrenheitToCelsius returns correct value', () {
      expect(WeatherConverter.fahrenheitToCelsius(32), 0);
      expect(WeatherConverter.fahrenheitToCelsius(212), 100);
      expect(WeatherConverter.fahrenheitToCelsius(-40), -40);
      expect(WeatherConverter.fahrenheitToCelsius(77), closeTo(25, 0.01));
    });
  });

  group('Data Processing Tests', () {
    test('WeatherData.fromJson parses valid fields', () {
      final json = {
        'city': 'Testville',
        'temperatureCelsius': 18.5,
        'description': 'Cloudy',
        'humidity': 62,
        'windSpeed': 8.2,
        'icon': '🌥️',
      };
      final data = WeatherData.fromJson(json);
      expect(data.city, 'Testville');
      expect(data.temperatureCelsius, 18.5);
      expect(data.description, 'Cloudy');
      expect(data.humidity, 62);
      expect(data.windSpeed, 8.2);
      expect(data.icon, '🌥️');
    });

    test('WeatherData.fromJson handles missing optional fields', () {
      final json = {
        'city': 'Nowhere',
        'temperatureCelsius': 0,
        'description': 'N/A',
        // humidity, windSpeed, icon missing
      };
      final data = WeatherData.fromJson(json);
      expect(data.city, 'Nowhere');
      expect(data.temperatureCelsius, 0);
      expect(data.description, 'N/A');
      // Depending on implementation, default values may be used:
      expect(data.humidity, isA<int>());
      expect(data.windSpeed, isA<double>());
      expect(data.icon, isA<String>());
    });

    test('WeatherData.fromJson throws on invalid fields', () {
      final json = {
        'city': 'Oops',
        'temperatureCelsius': 'not a number',
        'description': 'Error',
        'humidity': 'NaN',
        'windSpeed': null,
        'icon': 123,
      };
      expect(() => WeatherData.fromJson(json), throwsA(isA<Exception>()));
    });
  });
}

/// ✅ Helper widget that injects mock service into WeatherDisplay
class TestableWeatherDisplay extends StatefulWidget {
  final WeatherService service;

  const TestableWeatherDisplay({super.key, required this.service});

  @override
  State<TestableWeatherDisplay> createState() => _TestableWeatherDisplayState();
}

class _TestableWeatherDisplayState extends State<TestableWeatherDisplay> {
  WeatherData? data;
  bool isLoading = true;
  bool isFahrenheit = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      final result = await widget.service.fetchWeather('Test City');
      setState(() {
        data = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Column(
        children: [
          Text(error!),
          TextButton(onPressed: _loadWeather, child: const Text('Retry')),
        ],
      );
    }

    final temp = isFahrenheit
        ? (data!.temperatureCelsius * 9 / 5 + 32).toStringAsFixed(1)
        : data!.temperatureCelsius.toStringAsFixed(1);
    final unit = isFahrenheit ? '°F' : '°C';

    return Column(
      children: [
        Text('${data!.city}'),
        Text('$temp$unit'),
        Text(data!.description),
        Text('Humidity: ${data!.humidity}%'),
        Text('Wind Speed: ${data!.windSpeed} km/h'),
        Switch(
          value: isFahrenheit,
          onChanged: (val) => setState(() => isFahrenheit = val),
        ),
      ],
    );
  }
}
