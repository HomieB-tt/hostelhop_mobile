import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../data/providers/data_providers.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../widgets/gradient_button.dart';

class OTPVerificationSheet extends ConsumerStatefulWidget {
  const OTPVerificationSheet({
    super.key,
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  ConsumerState<OTPVerificationSheet> createState() => _OTPVerificationSheetState();
}

class _OTPVerificationSheetState extends ConsumerState<OTPVerificationSheet> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().isEmpty) {
      SnackBarUtils.showError(context, 'Please enter the OTP');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.verifyPhoneOtp(widget.phoneNumber, _otpController.text.trim());
      
      final user = ref.read(currentUserProvider);
      if (user != null) {
        await ref.read(profileRepositoryProvider).confirmPhone(user.id);
        // ignore: unused_result
        ref.refresh(currentProfileProvider);
        if (mounted) {
          SnackBarUtils.showSuccess(context, 'Phone number confirmed!');
          Navigator.of(context).pop(true); // Return true for success
        }
      }
    } catch (e) {
      if (mounted) SnackBarUtils.showError(context, 'Verification failed: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.hhColors;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Verify Phone Number', style: AppTypography.titleLarge.copyWith(color: colors.textHigh)),
          const SizedBox(height: 16),
          Text('Enter the OTP sent to ${widget.phoneNumber}', style: AppTypography.bodyMedium.copyWith(color: colors.textMid)),
          const SizedBox(height: 24),
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter OTP',
              filled: true,
              fillColor: colors.surfaceElevated,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          const SizedBox(height: 24),
          GradientButton(
            onPressed: _isLoading ? () {} : _verifyOtp,
            text: _isLoading ? 'Verifying...' : 'Verify OTP',
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
