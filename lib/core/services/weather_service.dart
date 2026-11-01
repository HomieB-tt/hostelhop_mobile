import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/app_constants.dart';
import '../../data/models/models.dart';

class WeatherService {
  final String _apiKey = AppConstants.openWeatherApiKey;
  final String _baseUrl = '${AppConstants.openWeatherBaseUrl.endsWith('/') ? AppConstants.openWeatherBaseUrl : '${AppConstants.openWeatherBaseUrl}/'}data/2.5';

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
