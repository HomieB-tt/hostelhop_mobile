import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  final String _apiKey = String.fromEnvironment(
    'OPENWEATHERMAP_API_KEY',
    defaultValue: '',
  );
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  WeatherService();

  Future<Map<String, dynamic>> getCurrentWeather(
    double latitude,
    double longitude,
  ) async {
    final url =
        '$_baseUrl/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
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
