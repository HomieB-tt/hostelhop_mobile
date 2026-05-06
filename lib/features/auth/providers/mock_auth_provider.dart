import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelhop_mobile/core/models/mock_user.dart';

// State enum for auth status
enum AuthStatus { checking, authenticated, unauthenticated }

// Auth state holder
class AuthState {
  final AuthStatus status;
  final MockUser? user;
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
    MockUser? user,
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

// Mock Auth notifier using Riverpod (uses mock data instead of Supabase)
class MockAuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _checkAuthStatus();
    return const AuthState(status: AuthStatus.checking);
  }

  Future<void> _checkAuthStatus() async {
    // Simulate checking auth status with mock data
    await Future.delayed(const Duration(milliseconds: 500));

    // For now, start as unauthenticated - can be changed to simulate logged in user
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      isLoading: false,
    );
  }

  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    // Mock validation - accept any valid-looking input
    if (email.isEmpty || password.isEmpty || password.length < 6) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Invalid email or password',
        isLoading: false,
      );
      return false;
    }

    // Simulate successful login with mock user
    final mockUser = MockUser(id: 'mock-user-id', email: email);

    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: mockUser,
      isLoading: false,
    );
    return true;
  }

  Future<bool> signUp(String email, String password, String fullName) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    if (email.isEmpty ||
        password.isEmpty ||
        fullName.isEmpty ||
        password.length < 6) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Please fill in all fields correctly',
        isLoading: false,
      );
      return false;
    }

    // Simulate successful account creation
    final mockUser = MockUser(
      id: 'mock-user-id-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
    );

    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: mockUser,
      isLoading: false,
    );
    return true;
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 800));
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

// Provider for MockAuthNotifier
final mockAuthProvider = NotifierProvider<MockAuthNotifier, AuthState>(MockAuthNotifier.new);

// Provider for accessing auth state
final mockAuthStateProvider = Provider<AuthState>((ref) {
  final authState = ref.watch(mockAuthProvider);
  return authState;
});

// Provider for checking if user is authenticated
final mockIsAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(mockAuthProvider);
  return authState.status == AuthStatus.authenticated;
});

// Provider for accessing current user
final mockCurrentUserProvider = Provider<MockUser?>((ref) {
  final authState = ref.watch(mockAuthProvider);
  return authState.user;
});

// Provider for checking if auth status is still checking
final mockIsCheckingAuthProvider = Provider<bool>((ref) {
  final authState = ref.watch(mockAuthProvider);
  return authState.status == AuthStatus.checking;
});

// Provider for auth error message
final mockAuthErrorMessageProvider = Provider<String?>((ref) {
  final authState = ref.watch(mockAuthProvider);
  return authState.errorMessage;
});

// Provider for auth loading state
final mockIsAuthLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(mockAuthProvider);
  return authState.isLoading;
});
