import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/snackbar_utils.dart';
import '../core/utils/validators.dart';
import '../data/providers/data_providers.dart';
import '../features/auth/providers/auth_provider.dart';
import 'gradient_button.dart';

/// Bottom sheet that sends an SMS code to [phoneNumber] and confirms it.
///
/// Pops with `true` only after Supabase has accepted the code.
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
  bool _isSending = false;
  bool _isVerifying = false;
  bool _codeSent = false;
  // True once Supabase accepted the code; a retry then only re-runs the
  // profile update instead of re-submitting an already-used code.
  bool _phoneVerified = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _sendCode());
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  String get _e164Phone => Validators.fullPhone(widget.phoneNumber);

  Future<void> _sendCode() async {
    if (widget.phoneNumber.replaceAll(RegExp(r'[^\d]'), '').isEmpty) {
      setState(() => _error = 'Add a phone number to your profile first.');
      return;
    }

    setState(() {
      _isSending = true;
      _error = null;
    });
    final error =
        await ref.read(authProvider.notifier).requestPhoneVerification(_e164Phone);
    if (!mounted) return;
    setState(() {
      _isSending = false;
      _codeSent = error == null;
      _error = error;
    });
  }

  Future<void> _verifyOtp() async {
    final code = _otpController.text.trim();
    if (code.isEmpty && !_phoneVerified) {
      SnackBarUtils.showError(context, 'Please enter the code');
      return;
    }

    setState(() {
      _isVerifying = true;
      _error = null;
    });

    if (!_phoneVerified) {
      final error =
          await ref.read(authProvider.notifier).verifyPhone(_e164Phone, code);
      if (!mounted) return;
      if (error != null) {
        setState(() {
          _isVerifying = false;
          _error = error;
        });
        return;
      }
      _phoneVerified = true;
    }

    try {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        await ref.read(profileRepositoryProvider).confirmPhone(user.id);
      }
      ref.invalidate(currentProfileProvider);
      if (!mounted) return;
      SnackBarUtils.showSuccess(context, 'Phone number confirmed!');
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isVerifying = false;
        _error = 'Phone verified, but we could not update your profile. Tap Verify to retry.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.hhColors;
    final busy = _isSending || _isVerifying;

    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Verify Phone Number', style: AppTypography.titleLarge.copyWith(color: colors.textHigh)),
          const SizedBox(height: 16),
          Text(
            _isSending
                ? 'Sending a code to $_e164Phone...'
                : _codeSent
                    ? 'Enter the code sent to $_e164Phone'
                    : 'We could not send a code to $_e164Phone',
            style: AppTypography.bodyMedium.copyWith(color: colors.textMid),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            enabled: _codeSent && !_phoneVerified,
            decoration: InputDecoration(
              hintText: 'Enter code',
              filled: true,
              fillColor: colors.surfaceElevated,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: AppTypography.bodySmall.copyWith(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          GradientButton(
            onPressed: (busy || (!_codeSent && !_phoneVerified)) ? () {} : _verifyOtp,
            text: _isVerifying ? 'Verifying...' : 'Verify',
            width: double.infinity,
          ),
          TextButton(
            onPressed: (busy || _phoneVerified) ? null : _sendCode,
            child: Text(_codeSent ? 'Resend code' : 'Try again'),
          ),
        ],
      ),
    );
  }
}
