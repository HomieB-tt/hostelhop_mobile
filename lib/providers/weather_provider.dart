import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/weather_service.dart';
import '../core/services/location_service.dart';
import '../data/models/models.dart';

final weatherServiceProvider = Provider((ref) => WeatherService());
final locationServiceProvider = Provider((ref) => LocationService());

final weatherProvider = FutureProvider<WeatherInfo?>((ref) async {
  final locationService = ref.read(locationServiceProvider);
  final weatherService = ref.read(weatherServiceProvider);

  try {
    final position = await locationService.getCurrentPosition();
    if (position != null) {
      return await weatherService.getCurrentWeather(
        position.latitude,
        position.longitude,
      );
    }
  } catch (e) {
    // Return null or handle error accordingly
    return null;
  }
  return null;
});
