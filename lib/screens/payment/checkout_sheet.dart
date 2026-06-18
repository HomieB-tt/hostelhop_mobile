import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/providers/data_providers.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../widgets/otp_verification_sheet.dart';
import '../../widgets/gradient_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// Half-screen checkout bottom sheet.
///
/// Slides up, user confirms details, taps Pay Now,
/// loading state → success/failure state.
class CheckoutSheet extends ConsumerStatefulWidget {
  const CheckoutSheet({
    super.key,
    required this.hostel,
    required this.room,
    required this.paymentMethod,
    required this.phoneNumber,
  });

  final Hostel hostel;
  final Room room;
  final String paymentMethod;
  final String phoneNumber;

  @override
  ConsumerState<CheckoutSheet> createState() => _CheckoutSheetState();
}

enum _CheckoutState { confirm, processing, success, failed }

class _CheckoutSheetState extends ConsumerState<CheckoutSheet>
    with SingleTickerProviderStateMixin {
  _CheckoutState _state = _CheckoutState.confirm;
  late final AnimationController _checkController;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    setState(() => _state = _CheckoutState.processing);

    final user = ref.read(currentUserProvider);
    final profile = ref.read(currentProfileProvider).value;

    if (user == null || profile == null) {
      if (mounted) SnackBarUtils.showError(context, 'You must be logged in to pay.');
      setState(() => _state = _CheckoutState.failed);
      return;
    }

    if (!profile.isPhoneConfirmed) {
      final confirmed = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => OTPVerificationSheet(phoneNumber: profile.phone),
      );

      if (confirmed != true) {
        if (mounted) SnackBarUtils.showError(context, 'Phone verification required to pay.');
        setState(() => _state = _CheckoutState.confirm);
        return;
      }
    }

    try {
      // 1. Create booking (Pending)
      final bookingRepo = ref.read(bookingsRepositoryProvider);
      final bookingId = await bookingRepo.createBooking(
        studentId: user.id,
        roomId: widget.room.id,
        amount: widget.room.pricePerSemester,
      );

      // Simulate payment success
      await Future.delayed(const Duration(seconds: 2));
      
      // 2. Confirm booking (this will update status and occupancy)
      await bookingRepo.confirmBooking(bookingId);

      // Remove from saved if it was saved
      ref.read(savedHostelsProvider.notifier).toggle(widget.hostel.id);

      if (mounted) {
        setState(() => _state = _CheckoutState.success);
        _checkController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _state = _CheckoutState.failed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.hhColors;
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.62,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: _buildContent(colors, theme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(HostelHopColors colors, ThemeData theme) {
    switch (_state) {
      case _CheckoutState.confirm:
        return _buildConfirmState(colors, theme);
      case _CheckoutState.processing:
        return _buildProcessingState(colors);
      case _CheckoutState.success:
        return _buildSuccessState(colors);
      case _CheckoutState.failed:
        return _buildFailedState(colors);
    }
  }

  Widget _buildConfirmState(HostelHopColors colors, ThemeData theme) {
    return Column(
      key: const ValueKey('confirm'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Payment',
          style: AppTypography.headlineSmall.copyWith(color: colors.textHigh),
        ),
        const SizedBox(height: 16),

        // Scrollable details area
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow('Hostel', widget.hostel.name, colors),
                _DetailRow('Room', widget.room.roomType, colors),
                _DetailRow('Method', widget.paymentMethod, colors),
                _DetailRow('Phone', widget.phoneNumber, colors),
                const SizedBox(height: 8),
                Divider(color: theme.colorScheme.outline),
                const SizedBox(height: 8),
                _DetailRow(
                  'Amount',
                  Formatters.formatUGX(widget.room.pricePerSemester),
                  colors,
                  isBold: true,
                ),
                const SizedBox(height: 16),

                // Info text
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warningSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          AppStrings.pinPrompt,
                          style: AppTypography.bodySmall.copyWith(
                            color: colors.textMid,
                            fontSize: 11,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Pinned button at bottom
        const SizedBox(height: 12),
        GradientButton(
          onPressed: _processPayment,
          text: AppStrings.payNow,
          icon: Icons.lock_rounded,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildProcessingState(HostelHopColors colors) {
    return Center(
      key: const ValueKey('processing'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.orangeBright,
              backgroundColor: AppColors.orangeBright.withValues(alpha: 0.15),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.processingPayment,
            style: AppTypography.titleMedium.copyWith(color: colors.textHigh),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your phone for a PIN prompt',
            style: AppTypography.bodySmall.copyWith(color: colors.textMid),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(HostelHopColors colors) {
    return Center(
      key: const ValueKey('success'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Check circle
          ScaleTransition(
            scale: CurvedAnimation(
              parent: _checkController,
              curve: Curves.elasticOut,
            ),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.successSoft,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 40,
                color: AppColors.success,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.paymentSuccessful,
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your room has been locked!\nBooking confirmation sent.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: colors.textMid,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          GradientButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            text: 'Back to Home',
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildFailedState(HostelHopColors colors) {
    return Center(
      key: const ValueKey('failed'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.errorSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close_rounded,
              size: 40,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Payment Failed',
            style: AppTypography.headlineSmall.copyWith(color: AppColors.error),
          ),
          const SizedBox(height: 8),
          Text(
            'Something went wrong. Please try again.',
            style: AppTypography.bodyMedium.copyWith(color: colors.textMid),
          ),
          const SizedBox(height: 32),
          GradientButton(
            onPressed: () => setState(() => _state = _CheckoutState.confirm),
            text: 'Try Again',
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value, this.colors, {this.isBold = false});

  final String label;
  final String value;
  final HostelHopColors colors;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(color: colors.textMid),
          ),
          Text(
            value,
            style:
                (isBold ? AppTypography.titleMedium : AppTypography.bodyMedium)
                    .copyWith(
                      color: colors.textHigh,
                      fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
                    ),
          ),
        ],
      ),
    );
  }
}
