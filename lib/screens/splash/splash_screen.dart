import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/loading_dots.dart';

/// Splash screen with orange gradient, animated sun orb, and loading dots.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _fadeController;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Sun orb pulse animation (looping).
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Fade-in for content.
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    // Navigate after delay.
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              const Spacer(flex: 3),

              // ── Sun orb ──
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: child,
                  );
                },
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.9),
                        AppColors.orangeBright.withValues(alpha: 0.6),
                        AppColors.orangePrimary.withValues(alpha: 0.2),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.35, 0.65, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.25),
                        blurRadius: 60,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.95),
                            const Color(0xFFFFD54F),
                            AppColors.orangeBright,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // ── Brand name ──
              RichText(
                text: TextSpan(
                  style: AppTypography.headlineLarge.copyWith(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                  children: const [
                    TextSpan(
                      text: 'Hostel',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    TextSpan(
                      text: 'Hop',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFFFE0B2), // light orange tint
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ── Tagline ──
              Text(
                AppStrings.tagline,
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  letterSpacing: 3.0,
                ),
              ),

              const Spacer(flex: 4),

              // ── Loading dots ──
              const LoadingDots(color: Colors.white),

              const SizedBox(height: 8),

              Text(
                AppStrings.loading,
                style: AppTypography.copyright.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                  letterSpacing: 3.0,
                ),
              ),

              const SizedBox(height: 24),

              // ── Copyright ──
              Text(
                AppStrings.copyright,
                style: AppTypography.copyright.copyWith(
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
