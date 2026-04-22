import 'package:flutter/material.dart';

/// Mock auth provider for Phase 1.
///
/// Simulates authentication state without hitting Supabase.
/// Will be replaced with real Supabase auth in Phase 2.
class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  bool _hasSeenOnboarding = false;
  String? _userName;
  String? _phoneNumber;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  String? get userName => _userName;
  String? get phoneNumber => _phoneNumber;
  String? get errorMessage => _errorMessage;

  /// Simulate sign in.
  Future<bool> signIn({
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulate network delay.
    await Future.delayed(const Duration(milliseconds: 1200));

    // Mock validation — accept any valid-looking input.
    if (phone.length < 9 || password.length < 6) {
      _errorMessage = 'Invalid phone number or password';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isAuthenticated = true;
    _userName = 'Brian Sserwadda'; // Mock user
    _phoneNumber = phone;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// Simulate sign up.
  Future<bool> signUp({
    required String fullName,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    _isAuthenticated = true;
    _userName = fullName;
    _phoneNumber = phone;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// Sign out.
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));

    _isAuthenticated = false;
    _userName = null;
    _phoneNumber = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Mark onboarding as seen.
  void completeOnboarding() {
    _hasSeenOnboarding = true;
    notifyListeners();
  }

  /// Clear any error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
