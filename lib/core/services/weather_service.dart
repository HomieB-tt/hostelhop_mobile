import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../data/models/models.dart';

class WeatherService {
  final String _apiKey = const String.fromEnvironment(
    'OPENWEATHERMAP_API_KEY',
    defaultValue: '788d40775a746e7f867497194f48b045', // Provided for testing if needed, or I'll use a placeholder
  );
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  WeatherService();

  Future<WeatherInfo> getCurrentWeather(
    double latitude,
    double longitude,
  ) async {
    final url =
        '$_baseUrl/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric';
    
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return WeatherInfo.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to weather service: $e');
    }
  }

  Future<Map<String, dynamic>> getForecast(
    double latitude,
    double longitude,
  ) async {
    final url =
        '$_baseUrl/forecast?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
}
