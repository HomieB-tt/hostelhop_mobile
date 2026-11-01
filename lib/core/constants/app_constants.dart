/// Build-time configuration.
///
/// Values are injected with `--dart-define-from-file=.env` (see README) rather
/// than bundled as an asset, so no config file ships inside the app and CI can
/// build without one. Note that anything compiled into a client app can still
/// be extracted from it: never put server secrets (payment provider secrets,
/// service-role keys) here.
class AppConstants {
  AppConstants._();

  // Supabase (the anon key is designed to be public; protect data with RLS).
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  // Firebase
  static const String firebaseApiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const String firebaseAppId = String.fromEnvironment('FIREBASE_APP_ID');
  static const String firebaseMessagingSenderId =
      String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
  static const String firebaseProjectId =
      String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const String firebaseStorageBucket =
      String.fromEnvironment('FIREBASE_STORAGE_BUCKET');

  // Third-party APIs (restrict these keys by app/package in their consoles).
  static const String openWeatherApiKey =
      String.fromEnvironment('OPENWEATHER_API_KEY');
  static const String openWeatherBaseUrl = String.fromEnvironment(
    'OPENWEATHER_BASE_URL',
    defaultValue: 'https://api.openweathermap.org/',
  );
  static const String googleMapsApiKey =
      String.fromEnvironment('GOOGLE_MAPS_API_KEY');

  // App constants
  static const String appName = 'HostelHop';
  static const String version = '0.1.0';

  /// Names of required settings that are empty in this build.
  static List<String> get missingRequired => [
        if (supabaseUrl.isEmpty) 'SUPABASE_URL',
        if (supabaseAnonKey.isEmpty) 'SUPABASE_ANON_KEY',
        if (firebaseApiKey.isEmpty) 'FIREBASE_API_KEY',
        if (firebaseAppId.isEmpty) 'FIREBASE_APP_ID',
        if (firebaseMessagingSenderId.isEmpty) 'FIREBASE_MESSAGING_SENDER_ID',
        if (firebaseProjectId.isEmpty) 'FIREBASE_PROJECT_ID',
      ];
}
