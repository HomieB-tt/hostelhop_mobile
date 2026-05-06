import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelhop_mobile/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// State enum for auth status
enum AuthStatus { checking, authenticated, unauthenticated }

// Auth state holder
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
    this.isLoading = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Auth notifier using Riverpod
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _checkAuthStatus();
    return const AuthState(status: AuthStatus.checking);
  }

  Future<void> _checkAuthStatus() async {
    try {
      final user = await ref.read(supabaseServiceProvider).getCurrentUser();
      if (user != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await ref.read(supabaseServiceProvider).signInWithEmail(email, password);
      if (response != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: response.user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'Invalid email or password',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> signUp(String email, String password, String fullName, String phone, String campusId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await ref.read(supabaseServiceProvider).signUpWithEmail(email, password, fullName, phone, campusId);
      if (response.user != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: response.user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'Failed to create account',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> signInWithPhone(String phone) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await ref.read(supabaseServiceProvider).signInWithPhone(phone);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> verifyPhoneOtp(String phone, String token) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final session = await ref.read(supabaseServiceProvider).verifyPhoneOtp(phone, token);
      if (session != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: session.user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'Invalid OTP',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(supabaseServiceProvider).signOut();
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }
}

// Provider for SupabaseService
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService.init();
});

// Provider for AuthNotifier
final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

// Provider for accessing auth state
final authStateProvider = Provider<AuthState>((ref) {
  final authState = ref.watch(authProvider);
  return authState;
});

// Provider for checking if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.status == AuthStatus.authenticated;
});

// Provider for accessing current user
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user;
});

// Provider for checking if auth status is still checking
final isCheckingAuthProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.status == AuthStatus.checking;
});

// Provider for auth error message
final authErrorMessageProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.errorMessage;
});

// Provider for auth loading state
final isAuthLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isLoading;
});
