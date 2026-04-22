import 'package:flutter/material.dart';

/// Named route constants and route generator.
class AppRouter {
  AppRouter._();

  // ── Route names ──
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String hostelDetail = '/hostel-detail';
  static const String booking = '/booking';
  static const String myBookings = '/my-bookings';
  static const String payment = '/payment';
  static const String profile = '/profile';
  static const String settings = '/settings';

  /// Standard page transition (slide from right).
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    return PageRouteBuilder(
      settings: routeSettings,
      pageBuilder: (context, animation, secondaryAnimation) {
        // Pages are resolved in the app shell, not here.
        // This is a fallback for unknown routes.
        return const Scaffold(
          body: Center(child: Text('Page not found')),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
