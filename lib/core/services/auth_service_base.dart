import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthServiceBase {
  Future<User?> signInWithEmail(String email, String password);
  Future<User?> signUpWithEmail(String email, String password);
  Future<void> signOut();
  Future<User?> getCurrentUser();
  Stream<AuthState> get authStateChanges;
}
