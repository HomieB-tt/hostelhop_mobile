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
  final String? noticeMessage;
  final bool isLoading;

  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
    this.noticeMessage,
    this.isLoading = false,
  });

  /// Passing `null` for a field keeps its current value. Use the `clear*`
  /// flags to explicitly reset a nullable field back to `null`.
  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    String? noticeMessage,
    bool? isLoading,
    bool clearUser = false,
    bool clearError = false,
    bool clearNotice = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      noticeMessage: clearNotice ? null : (noticeMessage ?? this.noticeMessage),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

String _messageFrom(Object e) => e.toString().replaceAll('Exception: ', '');

// Auth notifier using Riverpod
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Keep in sync with Supabase (token refresh, sign-out from elsewhere,
    // session recovery) instead of only reading the user once at startup.
    final subscription =
        ref.read(supabaseServiceProvider).authStateChanges.listen((data) {
      final session = data.session;
      if (session != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: session.user,
        );
      } else if (data.event == AuthChangeEvent.signedOut) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    });
    ref.onDispose(subscription.cancel);

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
        errorMessage: _messageFrom(e),
        isLoading: false,
      );
    }
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(
        isLoading: true, clearError: true, clearNotice: true);
    try {
      final response =
          await ref.read(supabaseServiceProvider).signInWithEmail(email, password);
      if (response != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: response.user,
          isLoading: false,
          clearError: true,
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
        errorMessage: _messageFrom(e),
        isLoading: false,
      );
    }
  }

  Future<void> signUp(String email, String password, String fullName,
      String phone, String campusId) async {
    state = state.copyWith(
        isLoading: true, clearError: true, clearNotice: true);
    try {
      final response = await ref
          .read(supabaseServiceProvider)
          .signUpWithEmail(email, password, fullName, phone, campusId);
      if (response.session != null) {
        // Signed in straight away (email confirmation disabled in Supabase).
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: response.user,
          isLoading: false,
          clearError: true,
        );
      } else if (response.user != null) {
        // Account exists but there is no session yet: the email still needs
        // to be confirmed, so the user is NOT authenticated.
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
          clearError: true,
          noticeMessage:
              'Account created. Check your email to confirm your address, then sign in.',
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
        errorMessage: _messageFrom(e),
        isLoading: false,
      );
    }
  }

  /// Sends an SMS code to attach [phone] (E.164) to the signed-in user.
  /// Returns an error message, or `null` on success. Does not touch the
  /// global auth status, so a failure here can never log the user out.
  Future<String?> requestPhoneVerification(String phone) async {
    try {
      await ref.read(supabaseServiceProvider).requestPhoneVerification(phone);
      return null;
    } catch (e) {
      return _messageFrom(e);
    }
  }

  /// Verifies the SMS [code] for [phone]. Returns an error message, or
  /// `null` only when Supabase confirmed the code.
  Future<String?> verifyPhone(String phone, String code) async {
    try {
      final user =
          await ref.read(supabaseServiceProvider).verifyPhoneChange(phone, code);
      if (user == null) return 'Invalid or expired code. Please try again.';
      state = state.copyWith(user: user);
      return null;
    } catch (e) {
      return _messageFrom(e);
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(supabaseServiceProvider).signOut();
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(errorMessage: _messageFrom(e), isLoading: false);
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
