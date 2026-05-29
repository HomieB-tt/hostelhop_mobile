import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostelhop_mobile/features/auth/providers/auth_provider.dart';
import 'package:hostelhop_mobile/screens/auth/login_screen.dart';
import 'package:hostelhop_mobile/screens/auth/signup_screen.dart';
import 'package:hostelhop_mobile/screens/home/home_screen.dart';
import 'package:hostelhop_mobile/screens/home/home_shell.dart';
import 'package:hostelhop_mobile/screens/onboarding/onboarding_screen.dart';
import 'package:hostelhop_mobile/screens/profile/settings_screen.dart';
import 'package:hostelhop_mobile/screens/booking/my_bookings_screen.dart';
import 'package:hostelhop_mobile/screens/splash/splash_screen.dart';
import 'package:hostelhop_mobile/screens/search/search_screen.dart';
import 'package:hostelhop_mobile/screens/profile/edit_profile_screen.dart';
import 'package:hostelhop_mobile/screens/hostel_detail/rooms_list_screen.dart';
import 'package:hostelhop_mobile/screens/hostel_detail/room_detail_screen.dart';
import 'package:hostelhop_mobile/data/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final location = state.uri.toString();

      // Always allow these routes
      if (location == '/splash' ||
          location.startsWith('/onboarding') ||
          location.startsWith('/auth/') ||
          location.startsWith('/login') ||
          location.startsWith('/signup') ||
          location.startsWith('/home') ||
          location.startsWith('/search') ||
          location.startsWith('/rooms') ||
          location.startsWith('/room-detail')) {
        
        // But redirect authenticated users away from auth screens
        if (isAuthenticated &&
            (location.startsWith('/login') ||
                location.startsWith('/signup') ||
                location.startsWith('/onboarding'))) {
          return '/home';
        }
        return null;
      }

      // Guest access for everything else is fine as we handle auth checks in screens
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) => _fadeTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          duration: const Duration(milliseconds: 600),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) => _fadeTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          duration: const Duration(milliseconds: 500),
        ),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => _slideUpTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        pageBuilder: (context, state) => _slideUpTransitionPage(
          key: state.pageKey,
          child: const SignupScreen(),
        ),
      ),
      GoRoute(
        path: '/rooms',
        name: 'rooms',
        builder: (context, state) => RoomsListScreen(hostel: state.extra as Hostel),
      ),
      GoRoute(
        path: '/room-detail',
        name: 'room-detail',
        builder: (context, state) => RoomDetailScreen(room: state.extra as Room),
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
                pageBuilder: (context, state) => _fadeTransitionPage(
                  key: state.pageKey,
                  child: const HomeScreen(),
                  duration: const Duration(milliseconds: 400),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                pageBuilder: (context, state) => _NoTransitionPage(
                  key: state.pageKey,
                  child: const SearchScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/bookings',
                name: 'bookings',
                pageBuilder: (context, state) => _NoTransitionPage(
                  key: state.pageKey,
                  child: const MyBookingsScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                pageBuilder: (context, state) => _NoTransitionPage(
                  key: state.pageKey,
                  child: const SettingsScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'edit-profile',
                    name: 'edit-profile',
                    pageBuilder: (context, state) => const MaterialPage(
                      child: EditProfileScreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

// ──────────────────────────────────────
//  Custom Page Transitions
// ──────────────────────────────────────

/// Smooth fade transition between routes.
CustomTransitionPage<void> _fadeTransitionPage({
  required LocalKey key,
  required Widget child,
  Duration duration = const Duration(milliseconds: 350),
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

/// Slide-up transition (for auth screens).
CustomTransitionPage<void> _slideUpTransitionPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(opacity: curved, child: child),
      );
    },
  );
}

/// No transition (for bottom nav tab switches).
class _NoTransitionPage extends CustomTransitionPage<void> {
  _NoTransitionPage({required super.child, super.key})
      : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              child,
        );
}
