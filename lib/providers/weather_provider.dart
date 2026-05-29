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
    // Add a timeout to prevent hanging if location services are slow or unresponsive
    final position = await locationService.getCurrentPosition().timeout(
      const Duration(seconds: 5),
      onTimeout: () => null,
    );
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
