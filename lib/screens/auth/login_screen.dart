import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../core/routing/app_router.dart';
import '../../widgets/gradient_button.dart';

/// Login screen with orange header curve and white form card.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    // Use actual authProvider for Supabase login
    await ref.read(authProvider.notifier).signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final colors = context.hhColors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    // Listen for auth state changes to navigate
    ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        ref.read(goRouterProvider).go('/home');
      }
    });

    return Scaffold(
      backgroundColor: colors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        final headerHeight = (screenHeight * 0.42).clamp(280.0, 420.0);
        final cardTop = (screenHeight * 0.32).clamp(220.0, 360.0);
        return Stack(
        children: [
          // ── Orange gradient background header ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerHeight,
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.splashGradient,
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: (screenHeight * 0.04).clamp(16.0, 40.0)),
                    // Logo with glow
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.wb_sunny_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .shimmer(duration: 2000.ms, color: Colors.white30)
                        .scaleXY(begin: 0.95, end: 1.05, duration: 2000.ms),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.appName.toUpperCase(),
                      style: AppTypography.displayLarge.copyWith(
                        color: Colors.white,
                        letterSpacing: 4.0,
                        fontSize: 28,
                      ),
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
                    Text(
                      AppStrings.tagline,
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white70,
                        letterSpacing: 2.0,
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                  ],
                ),
              ),
            ),
          ),

          // ── Login form card ──
          Positioned.fill(
            top: cardTop,
            child: Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24, 40, 24, bottomInset + 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.welcomeBack,
                        style: AppTypography.headlineLarge.copyWith(
                          color: colors.textHigh,
                        ),
                      ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.signInSubtitle,
                        style: AppTypography.bodyMedium.copyWith(
                          color: colors.textMid,
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                      const SizedBox(height: 32),

                      // Email input
                      _buildLabel(AppStrings.emailLabel, colors),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                        decoration: InputDecoration(
                          hintText: AppStrings.emailHint,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

                      const SizedBox(height: 24),

                      // Password input
                      _buildLabel(AppStrings.passwordLabel, colors),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: Validators.password,
                        decoration: InputDecoration(
                          hintText: AppStrings.passwordHint,
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            AppStrings.forgotPassword,
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.orangeBright,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Error message
                      if (authState.errorMessage != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: AppColors.errorSoft,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  authState.errorMessage!,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().shake(duration: 400.ms),

                      // Sign In button
                      GradientButton(
                        onPressed: authState.isLoading ? null : _handleSignIn,
                        text: AppStrings.signIn.toUpperCase(),
                        icon: Icons.arrow_forward_rounded,
                        isLoading: authState.isLoading,
                        width: double.infinity,
                      ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 32),

                      // Footer
                      Center(
                        child: Column(
                          children: [
                            Text(
                              AppStrings.newToHostelHop,
                              style: AppTypography.bodyMedium.copyWith(color: colors.textMid),
                            ),
                            TextButton(
                              onPressed: () => ref.read(goRouterProvider).push('/signup'),
                              child: Text(
                                AppStrings.signUp.toUpperCase(),
                                style: AppTypography.titleMedium.copyWith(
                                  color: AppColors.orangeBright,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
        },
      ),
    );
  }

  Widget _buildLabel(String text, HostelHopColors colors) {
    return Text(
      text,
      style: AppTypography.labelMedium.copyWith(
        color: colors.textMid,
        letterSpacing: 1.2,
      ),
    );
  }
}
