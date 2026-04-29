class AppConstants {
  // Supabase configuration - these should be set via environment variables or flavor configurations
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  // API Keys
  static const String openWeatherMapApiKey = String.fromEnvironment(
    'OPENWEATHERMAP_API_KEY',
    defaultValue: '',
  );
  static const String googlePlacesApiKey = String.fromEnvironment(
    'GOOGLE_PLACES_API_KEY',
    defaultValue: '',
  );

  // PesaPal configuration would go here (typically handled via their SDK or secure backend)

  // App constants
  static const String appName = 'HostelHop';
  static const String version = '0.1.0';
}
