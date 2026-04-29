import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _supabase;

  SupabaseService._internal(this._supabase);

  factory SupabaseService.init() {
    return SupabaseService._internal(Supabase.instance.client);
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

  Future<AuthResponse> signUpWithEmail(String email, String password, String fullName, String phone) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'phone_number': phone},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithPhone(String phone) async {
    try {
      await _supabase.auth.signInWithOtp(phone: phone);
    } catch (e) {
      rethrow;
    }
  }

  Future<Session?> verifyPhoneOtp(String phone, String token) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        type: OtpType.sms,
        token: token,
        phone: phone,
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
