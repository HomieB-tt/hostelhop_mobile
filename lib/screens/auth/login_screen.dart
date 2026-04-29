import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../features/auth/providers/mock_auth_provider.dart';
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
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(mockAuthProvider.notifier)
        .signIn(_phoneController.text.trim(), _passwordController.text);

    if (mounted) {
      if (success) {
        // Navigate to home using GoRouter
        ref.read(goRouterProvider).go('/home');
      } else {
        // Error will be handled by the auth provider state
        // Show error snackbar if no error message from provider
        if (ref.read(mockAuthProvider).errorMessage == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Sign in failed')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(mockAuthProvider);
    final colors = context.hhColors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: Column(
        children: [
          // ── Orange header ──
          _buildHeader(context),

          // ── Form card ──
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Container(
                width: double.infinity,
                transform: Matrix4.translationValues(0, -28, 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          AppStrings.welcomeBack,
                          style: AppTypography.headlineMedium.copyWith(
                            color: colors.textHigh,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppStrings.signInSubtitle,
                          style: AppTypography.bodyMedium.copyWith(
                            color: colors.textMid,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Phone number
                        Text(
                          AppStrings.phoneLabel,
                          style: AppTypography.labelMedium.copyWith(
                            color: colors.textMid,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: Validators.phone,
                          decoration: InputDecoration(
                            hintText: AppStrings.phoneHint,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    '🇺🇬',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    AppStrings.phonePrefix,
                                    style: AppTypography.titleSmall.copyWith(
                                      color: colors.textHigh,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 1,
                                    height: 24,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Password
                        Text(
                          AppStrings.passwordLabel,
                          style: AppTypography.labelMedium.copyWith(
                            color: colors.textMid,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          validator: Validators.password,
                          decoration: InputDecoration(
                            hintText: AppStrings.passwordHint,
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              color: colors.textHigh,
                              size: 20,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Text(
                                  _obscurePassword ? 'Show' : 'Hide',
                                  style: AppTypography.labelMedium.copyWith(
                                    color: colors.textMid,
                                  ),
                                ),
                              ),
                            ),
                            suffixIconConstraints: const BoxConstraints(
                              minWidth: 0,
                              minHeight: 0,
                            ),
                          ),
                        ),

                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              AppStrings.forgotPassword,
                              style: AppTypography.labelMedium.copyWith(
                                color: colors.link,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Error message
                        if (authState.errorMessage != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.error.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              authState.errorMessage!,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                        // Sign In button
                        GradientButton(
                          onPressed: authState.isLoading ? null : _handleSignIn,
                          text: AppStrings.signIn,
                          icon: Icons.login_rounded,
                          isLoading: authState.isLoading,
                          width: double.infinity,
                        ),

                        const SizedBox(height: 20),

                        // New to HostelHop?
                        Center(
                          child: Text(
                            AppStrings.newToHostelHop,
                            style: AppTypography.bodySmall.copyWith(
                              color: colors.textMid,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Create Account button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                ref.read(goRouterProvider).go('/signup'),
                            icon: const Icon(
                              Icons.person_add_alt_1_rounded,
                              size: 18,
                            ),
                            label: Text(AppStrings.signUp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 52,
      ),
      decoration: const BoxDecoration(gradient: AppColors.splashGradient),
      child: Column(
        children: [
          // Logo placeholder
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.apartment_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: AppTypography.headlineSmall.copyWith(color: Colors.white),
              children: const [
                TextSpan(text: 'Hostel'),
                TextSpan(
                  text: 'Hop',
                  style: TextStyle(color: Color(0xFFFFE0B2)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.tagline,
            style: AppTypography.labelSmall.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}
