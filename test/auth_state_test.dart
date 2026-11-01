import 'package:flutter_test/flutter_test.dart';
import 'package:hostelhop_mobile/features/auth/providers/auth_provider.dart';

void main() {
  group('AuthState.copyWith', () {
    const failed = AuthState(
      status: AuthStatus.unauthenticated,
      errorMessage: 'Invalid email or password',
      noticeMessage: 'Check your email',
    );

    test('keeps existing messages when none are passed', () {
      final next = failed.copyWith(isLoading: true);
      expect(next.errorMessage, 'Invalid email or password');
      expect(next.noticeMessage, 'Check your email');
      expect(next.isLoading, isTrue);
    });

    test('clearError / clearNotice reset them to null', () {
      final next = failed.copyWith(clearError: true, clearNotice: true);
      expect(next.errorMessage, isNull);
      expect(next.noticeMessage, isNull);
    });

    test('a new message replaces the old one', () {
      final next = failed.copyWith(errorMessage: 'No internet connection');
      expect(next.errorMessage, 'No internet connection');
    });

    test('status changes without touching other fields', () {
      final next = failed.copyWith(status: AuthStatus.authenticated);
      expect(next.status, AuthStatus.authenticated);
      expect(next.errorMessage, 'Invalid email or password');
    });
  });
}
