import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hostelhop_mobile/core/constants/app_constants.dart';

class SupabaseService {
  final SupabaseClient _supabase;

  SupabaseService._internal(this._supabase);

  factory SupabaseService.init() {
    final supabaseUrl = String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: AppConstants.supabaseUrl,
    );
    final supabaseAnonKey = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: AppConstants.supabaseAnonKey,
    );

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception('Supabase credentials are not configured');
    }

    final supabase = SupabaseClient(supabaseUrl, supabaseAnonKey);
    return SupabaseService._internal(supabase);
  }

  SupabaseClient get client => _supabase;

  // Auth methods
  Future<Session?> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.session;
    } catch (e) {
      rethrow;
    }
  }

  Future<Session?> signUpWithEmail(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response.session;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<User?> getCurrentUser() async {
    return _supabase.auth.currentUser;
  }

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Database methods will be added here
}
