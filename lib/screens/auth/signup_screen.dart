import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/gradient_button.dart';

/// Signup screen with full form, password strength meter, and T&C checkbox.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;
  int _passwordStrength = 0;
  bool _passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updateStrength);
    _confirmPasswordController.addListener(_updateMatch);
  }

  void _updateStrength() {
    setState(() {
      _passwordStrength = Validators.passwordStrength(_passwordController.text);
    });
    _updateMatch();
  }

  void _updateMatch() {
    setState(() {
      _passwordsMatch = _confirmPasswordController.text.isNotEmpty &&
          _confirmPasswordController.text == _passwordController.text;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms & Conditions'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.signUp(
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Color _strengthColor(int strength) {
    switch (strength) {
      case 0:
        return AppColors.error;
      case 1:
        return AppColors.warning;
      case 2:
        return AppColors.success;
      default:
        return AppColors.error;
    }
  }

  String _strengthLabel(int strength) {
    switch (strength) {
      case 0:
        return '${AppStrings.strengthWeak} ${AppStrings.strengthAddSymbol}';
      case 1:
        return '${AppStrings.strengthMedium} ${AppStrings.strengthAddSymbol}';
      case 2:
        return AppStrings.strengthStrong;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final colors = context.hhColors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: Column(
        children: [
          // ── Orange header ──
          _buildHeader(context),

          // ── Form ──
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomInset + 24),
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
                          AppStrings.createAccount,
                          style: AppTypography.headlineMedium.copyWith(
                            color: colors.textHigh,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppStrings.createAccountSubtitle,
                          style: AppTypography.bodyMedium.copyWith(
                            color: colors.textMid,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Full Name
                        _buildLabel(AppStrings.fullNameLabel, colors),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          validator: Validators.fullName,
                          decoration: InputDecoration(
                            hintText: AppStrings.fullNameHint,
                            suffixIcon: _nameController.text.trim().split(' ').length >= 2
                                ? const Icon(Icons.check_circle,
                                    color: AppColors.success, size: 20)
                                : null,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),

                        const SizedBox(height: 20),

                        // Phone number
                        _buildLabel(AppStrings.phoneLabel, colors),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: Validators.phone,
                          decoration: InputDecoration(
                            hintText: AppStrings.phoneHint,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 16, right: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('🇺🇬',
                                      style: TextStyle(fontSize: 18)),
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
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppStrings.phoneIdentifier,
                          style: AppTypography.bodySmall.copyWith(
                            color: colors.textLow,
                            fontSize: 11,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Password
                        _buildLabel(AppStrings.passwordLabel, colors),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          validator: Validators.password,
                          decoration: InputDecoration(
                            hintText: AppStrings.passwordHint,
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              color: colors.textLow,
                              size: 20,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
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

                        // Strength meter
                        if (_passwordController.text.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: (_passwordStrength + 1) / 3,
                                    backgroundColor: colors.surfaceElevated,
                                    valueColor: AlwaysStoppedAnimation(
                                      _strengthColor(_passwordStrength),
                                    ),
                                    minHeight: 4,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _strengthLabel(_passwordStrength),
                            style: AppTypography.bodySmall.copyWith(
                              color: _strengthColor(_passwordStrength),
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),

                        // Confirm Password
                        _buildLabel(AppStrings.confirmPasswordLabel, colors),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirm,
                          validator: (v) =>
                              Validators.confirmPassword(v, _passwordController.text),
                          decoration: InputDecoration(
                            hintText: AppStrings.confirmPasswordHint,
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              color: colors.textLow,
                              size: 20,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Text(
                                  _obscureConfirm ? 'Show' : 'Hide',
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

                        // Passwords match indicator
                        if (_passwordsMatch) ...[
                          const SizedBox(height: 6),
                          Text(
                            AppStrings.passwordsMatch,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),

                        // Terms checkbox
                        GestureDetector(
                          onTap: () =>
                              setState(() => _agreedToTerms = !_agreedToTerms),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                margin: const EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                  color: _agreedToTerms
                                      ? AppColors.orangeBright
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _agreedToTerms
                                        ? AppColors.orangeBright
                                        : colors.textLow,
                                    width: 2,
                                  ),
                                ),
                                child: _agreedToTerms
                                    ? const Icon(Icons.check,
                                        size: 14, color: Colors.white)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: AppTypography.bodySmall.copyWith(
                                      color: colors.textMid,
                                    ),
                                    children: [
                                      const TextSpan(
                                          text: 'I agree to the '),
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: TextStyle(
                                          color: AppColors.orangeBright,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: AppColors.orangeBright,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const TextSpan(
                                          text: ' of HostelHop.'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Create Account button
                        GradientButton(
                          onPressed: auth.isLoading ? null : _handleSignUp,
                          text: AppStrings.signUp,
                          isLoading: auth.isLoading,
                          width: double.infinity,
                        ),

                        const SizedBox(height: 20),

                        // Already have an account?
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: RichText(
                              text: TextSpan(
                                style: AppTypography.bodySmall.copyWith(
                                  color: colors.textLow,
                                ),
                                children: [
                                  const TextSpan(
                                      text:
                                          '${AppStrings.alreadyHaveAccount}  '),
                                  TextSpan(
                                    text: AppStrings.signIn,
                                    style: TextStyle(
                                      color: AppColors.orangeBright,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

  Widget _buildLabel(String text, HostelHopColors colors) {
    return Text(
      text,
      style: AppTypography.labelMedium.copyWith(
        color: colors.textMid,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 52,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.splashGradient,
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.apartment_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 10),
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
