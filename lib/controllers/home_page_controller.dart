import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePageController {
  final http.Client client;

  HomePageController({http.Client? client})
      : this.client = client ?? http.Client();
  Future<Map<String, dynamic>> fetchWeather(String location) async {
    final apiKey = 'c0a6cdd6c865202f7a7b2a57f7cbc944';
    final url = Uri.parse(
        'http://api.weatherstack.com/current?access_key=$apiKey&query=$location');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return {
          'temperature': jsonData['current']['temperature'],
          'wind_speed': jsonData['current']['wind_speed'],
          'wind_dir': jsonData['current']['wind_dir'],
          'name': jsonData['location']['name'],
          'lon': jsonData['location']['lon'],
          'lat': jsonData['location']['lat'],
          'country': jsonData['location']['country'],
        };
      } else {
        return {
          'error':
              'Failed to fetch weather data. Status code: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'error': 'Exception during request: $e'};
    }
  }

  Future<List<Map<String, dynamic>>> fetchForecast(String location) async {
    final apiKey = 'c0a6cdd6c865202f7a7b2a57f7cbc944';
    final urlForecast = Uri.parse(
        'http://api.weatherstack.com/forecast?access_key=$apiKey&query=$location&forecast_days=7');
    try {
      final response = await http.get(urlForecast);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final forecastData = jsonData['forecast'];
        List<Map<String, dynamic>> forecasts = [];

        forecastData.forEach((date, data) {
          Map<String, dynamic> dailyForecast = {
            'date': date,
            'maxTemp': data['maxtemp'],
            'minTemp': data['mintemp'],
            'avgTemp': data['avgtemp'],
            'totalSnow': data['totalsnow'],
          };
          forecasts.add(dailyForecast);
        });

        return forecasts;
      } else {
        throw Exception(
            'Failed to fetch forecast data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Exception during forecast fetch: $e');
    }
  }
}

List<String> getSuggestions(String query, String csvContent) {
  List<String> suggestions = [];
  List<List<dynamic>> rows = const CsvToListConverter().convert(csvContent);
  for (final row in rows) {
    final String resortName = row[0];
    if (resortName.toLowerCase().contains(query.toLowerCase())) {
      suggestions.add(resortName);
    }
  }
  return suggestions;
}

bool isValidSuggestion(String input, List<String> suggestions) {
  return suggestions
      .any((suggestion) => suggestion.toLowerCase() == input.toLowerCase());
}
