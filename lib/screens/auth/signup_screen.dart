import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/gradient_button.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedUniversityId;
  String? _selectedCampusId;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;
  int _passwordStrength = 0;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updateStrength);
  }

  void _updateStrength() {
    setState(() {
      _passwordStrength = Validators.passwordStrength(_passwordController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCampusId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your university campus'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms & Conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await ref
        .read(authProvider.notifier)
        .signUp(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
          _phoneController.text.trim(),
          _selectedCampusId!,
        );

    final authState = ref.read(authProvider);
    if (authState.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
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
    final authState = ref.watch(authProvider);
    final colors = context.hhColors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Stack(
        children: [
          // ── Gradient Header ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.orangeBright, AppColors.orangeDeep],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                          ),
                          Image.asset(
                            'assets/images/logo_white.png',
                            height: 32,
                            errorBuilder: (c, e, s) => Container(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Join HostelHop',
                        style: AppTypography.displaySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),
                      const SizedBox(height: 8),
                      Text(
                        'Find your perfect student home today.',
                        style: AppTypography.bodyLarge.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Main Card ──
          Positioned.fill(
            top: 220,
            child: Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 32,
                  bottom: bottomInset + 40,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name
                      _buildFieldLabel('Full Name'),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        validator: Validators.fullName,
                        decoration: _inputDecoration(
                          hint: 'Enter your full name',
                          icon: Icons.person_outline_rounded,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email
                      _buildFieldLabel('Email Address'),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                        decoration: _inputDecoration(
                          hint: 'yourname@example.com',
                          icon: Icons.email_outlined,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Phone
                      _buildFieldLabel('Phone Number'),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: Validators.phone,
                        decoration:
                            _inputDecoration(
                              hint: '772 123 456',
                              icon: Icons.phone_android_rounded,
                            ).copyWith(
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
                                    const SizedBox(width: 4),
                                    Text(
                                      '+256',
                                      style: AppTypography.bodyMedium.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colors.textHigh,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      height: 20,
                                      width: 1,
                                      color: colors.divider,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ),
                      const SizedBox(height: 20),

                      // University Selection
                      _buildFieldLabel('University'),
                      _buildDropdown<String>(
                        value: _selectedUniversityId,
                        hint: 'Select your university',
                        items: MockData.universities.map((u) {
                          return DropdownMenuItem<String>(
                            value: u['id'] as String,
                            child: Text(u['name'] as String),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedUniversityId = val;
                            _selectedCampusId = null; // Reset campus
                          });
                        },
                        icon: Icons.school_outlined,
                      ),
                      const SizedBox(height: 20),

                      // Campus Selection
                      if (_selectedUniversityId != null) ...[
                        _buildFieldLabel('Campus'),
                        _buildDropdown<String>(
                          value: _selectedCampusId,
                          hint: 'Select your campus',
                          items: MockData.campuses
                              .where(
                                (c) => c['univId'] == _selectedUniversityId,
                              )
                              .map((c) {
                                return DropdownMenuItem<String>(
                                  value: c['id'] as String,
                                  child: Text(c['name'] as String),
                                );
                              })
                              .toList(),
                          onChanged: (val) {
                            setState(() => _selectedCampusId = val);
                          },
                          icon: Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Password
                      _buildFieldLabel('Password'),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: Validators.password,
                        decoration:
                            _inputDecoration(
                              hint: 'Create a password',
                              icon: Icons.lock_outline_rounded,
                            ).copyWith(
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: colors.textLow,
                                  size: 20,
                                ),
                              ),
                            ),
                      ),

                      // Password Strength
                      if (_passwordController.text.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: (_passwordStrength + 1) / 3,
                            backgroundColor: colors.surfaceElevated,
                            valueColor: AlwaysStoppedAnimation(
                              _strengthColor(_passwordStrength),
                            ),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _strengthLabel(_passwordStrength),
                          style: AppTypography.labelSmall.copyWith(
                            color: _strengthColor(_passwordStrength),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Confirm Password
                      _buildFieldLabel('Confirm Password'),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirm,
                        validator: (v) => Validators.confirmPassword(
                          v,
                          _passwordController.text,
                        ),
                        decoration:
                            _inputDecoration(
                              hint: 'Confirm your password',
                              icon: Icons.lock_outline_rounded,
                            ).copyWith(
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm,
                                ),
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: colors.textLow,
                                  size: 20,
                                ),
                              ),
                            ),
                      ),
                      const SizedBox(height: 24),

                      // Terms & Conditions
                      GestureDetector(
                        onTap: () =>
                            setState(() => _agreedToTerms = !_agreedToTerms),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(top: 2),
                              decoration: BoxDecoration(
                                color: _agreedToTerms
                                    ? AppColors.orangeBright
                                    : Colors.transparent,
                                border: Border.all(
                                  color: _agreedToTerms
                                      ? AppColors.orangeBright
                                      : colors.textLow,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: _agreedToTerms
                                  ? const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: 'I agree to the ',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: colors.textMid,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: TextStyle(
                                        color: AppColors.orangeDeep,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        color: AppColors.orangeDeep,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Sign Up Button
                      GradientButton(
                        text: 'Create Account',
                        onPressed: _handleSignUp,
                        isLoading: authState.isLoading,
                      ),
                      const SizedBox(height: 24),

                      // Login Link
                      Center(
                        child: GestureDetector(
                          onTap: () => context.pop(),
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: AppTypography.bodyMedium.copyWith(
                                color: colors.textMid,
                              ),
                              children: const [
                                TextSpan(
                                  text: 'Login',
                                  style: TextStyle(
                                    color: AppColors.orangeDeep,
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
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: AppTypography.labelLarge.copyWith(
          color: context.hhColors.textHigh,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    final colors = context.hhColors;
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: colors.textLow, size: 20),
      filled: true,
      fillColor: colors.surfaceElevated.withValues(alpha: 0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.orangeBright, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required IconData icon,
  }) {
    final colors = context.hhColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colors.surfaceElevated.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Row(
            children: [
              Icon(icon, color: colors.textLow, size: 20),
              const SizedBox(width: 12),
              Text(
                hint,
                style: AppTypography.bodyMedium.copyWith(color: colors.textLow),
              ),
            ],
          ),
          isExpanded: true,
          items: items,
          onChanged: onChanged,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.textLow),
          borderRadius: BorderRadius.circular(16),
          dropdownColor: colors.surface,
          style: AppTypography.bodyMedium.copyWith(color: colors.textHigh),
        ),
      ),
    );
  }
}
