import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:slopesense/controllers/home_page_controller.dart';
import 'package:mockito/mockito.dart';
import 'mocks.mocks.dart'; // Import the generated mocks
import 'package:intl/intl.dart';

void main() {
  late MockClient mockClient;
  late HomePageController controller;

  setUp(() {
    mockClient = MockClient();
    controller = HomePageController(client: mockClient);
  });

  group('HomePageController', () {
    test('fetchWeather returns location-specific data on successful HTTP call',
        () async {
      final testLocation = 'Zermatt';
      final testUri = Uri.parse(
          'http://api.weatherstack.com/current?access_key=c0a6cdd6c865202f7a7b2a57f7cbc944&query=$testLocation');

      // Use the generated MockClient
      when(mockClient.get(testUri)).thenAnswer((_) async => http.Response(
          jsonEncode({
            "location": {
              "name": "Zermatt",
              "country": "Switzerland",
              "lat": 46.017,
              "lon": 7.750
            },
            "current": {
              "temperature": 20,
              "wind_speed": 10,
            }
          }),
          200));

      final result = await controller.fetchWeather(testLocation);

      expect(result['name'], equals('Zermatt'));
      expect(result['country'], equals('Switzerland'));
      expect(result['lat'], equals('46.017'));
      expect(result['lon'], equals('7.750'));
    });

    test(
        'fetchForecast returns a list of forecast data on successful HTTP call',
        () async {
      final testLocation = 'Zermatt';
      final testUri = Uri.parse(
          'http://api.weatherstack.com/forecast?access_key=c0a6cdd6c865202f7a7b2a57f7cbc944&query=$testLocation&forecast_days=7');
      final DateTime now = DateTime.now();
      final String formattedDate = DateFormat('yyyy-MM-dd').format(now);

      when(mockClient.get(testUri)).thenAnswer((_) async => http.Response(
          jsonEncode({
            "forecast": {
              formattedDate: {
                "maxtemp": 10,
                "mintemp": 5,
                "avgtemp": 7,
                "totalsnow": 0,
              }
            }
          }),
          200));

      final result = await controller.fetchForecast(testLocation);

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.first['date'], equals(formattedDate));
    });

    test('getSuggestions returns matching suggestions from CSV content', () {
      final String csvContent = "Zermatt";
      final String query = "Zer";
      final List<String> suggestions = getSuggestions(query, csvContent);

      expect(suggestions, contains('Zermatt'));
      expect(suggestions, isNot(contains('Val Gardena')));
    });

    test('isValidSuggestion returns true if input matches any suggestion', () {
      final List<String> suggestions = ["Zermatt", "Val Gardena"];
      final String input = "Val Gardena";

      final bool isValid = isValidSuggestion(input, suggestions);

      expect(isValid, isTrue);
    });
  });
}
