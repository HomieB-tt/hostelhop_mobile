import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostelhop_mobile/features/auth/providers/auth_provider.dart';
import 'package:hostelhop_mobile/screens/auth/login_screen.dart';
import 'package:hostelhop_mobile/screens/auth/signup_screen.dart';
import 'package:hostelhop_mobile/screens/explore/explore_screen.dart';
import 'package:hostelhop_mobile/screens/home/home_shell.dart';
import 'package:hostelhop_mobile/screens/onboarding/onboarding_screen.dart';
import 'package:hostelhop_mobile/screens/profile/profile_screen.dart';
import 'package:hostelhop_mobile/screens/splash/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isChecking = authState.status == AuthStatus.checking;
      final location = state.uri.toString();

      // Handle auth redirects
      if (location == '/splash' && !isAuthenticated && !isChecking) {
        // Still checking auth status, stay on splash
        return null;
      }

      if (location.startsWith('/auth/')) {
        // Already on auth pages, no redirect needed
        return null;
      }

      if (!isAuthenticated &&
          !location.startsWith('/onboarding') &&
          !location.startsWith('/login') &&
          !location.startsWith('/signup') &&
          !location.startsWith('/splash')) {
        // Not authenticated and trying to access protected route
        return '/login';
      }

      if (isAuthenticated &&
          (location.startsWith('/login') ||
              location.startsWith('/signup') ||
              location.startsWith('/onboarding'))) {
        // Authenticated but trying to access auth/onboarding pages
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: ExploreScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/bookings',
                name: 'bookings',
                pageBuilder: (context, state) => NoTransitionPage(
                  child: Center(child: Text('Bookings Screen')),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: ProfileScreen()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

// Helper class for custom page transitions
class NoTransitionPage extends CustomTransitionPage<void> {
  NoTransitionPage({required super.child, super.key})
    : super(
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
      );
}
