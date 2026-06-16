import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../data/models/models.dart';
import '../../data/providers/data_providers.dart';
import '../../widgets/gradient_button.dart';
import 'checkout_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Payment screen — select method and initiate payment.
class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key, required this.hostel, required this.room});

  final Hostel hostel;
  final Room room;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String _selectedMethod = 'MTN Mobile Money';
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);
    
    // Defer reading the provider until after initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(currentProfileProvider).value;
      if (profile != null && profile.phone.isNotEmpty) {
        _phoneController.text = profile.phone;
      }
    });
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    final text = _phoneController.text.replaceAll(' ', '');
    // Auto-detect logic
    // MTN: 077, 078, 076, 079
    // Airtel: 070, 075, 074
    
    // Normalize to handle +256
    String normalized = text;
    if (normalized.startsWith('+256')) {
      normalized = '0${normalized.substring(4)}';
    } else if (normalized.startsWith('256')) {
      normalized = '0${normalized.substring(3)}';
    }

    if (normalized.length >= 3) {
      final prefix = normalized.substring(0, 3);
      if (['077', '078', '076', '079'].contains(prefix)) {
        if (_selectedMethod != 'MTN Mobile Money') {
          setState(() => _selectedMethod = 'MTN Mobile Money');
        }
      } else if (['070', '075', '074'].contains(prefix)) {
        if (_selectedMethod != 'Airtel Money') {
          setState(() => _selectedMethod = 'Airtel Money');
        }
      }
    }
  }

  void _showCheckout() {
    // Validate phone
    if (_phoneController.text.trim().isEmpty) {
      SnackBarUtils.showError(context, 'Please enter a phone number');
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 400),
      ),
      builder: (context) => CheckoutSheet(
        hostel: widget.hostel,
        room: widget.room,
        paymentMethod: _selectedMethod,
        phoneNumber: _phoneController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.hhColors;
    final theme = Theme.of(context);
    final amount = widget.room.pricePerSemester;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: AppTypography.titleLarge.copyWith(color: colors.textHigh),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Summary card ──
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.bookingSummary,
                      style: AppTypography.labelMedium.copyWith(
                        color: colors.textLow,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SummaryRow(
                        label: 'Hostel',
                        value: widget.hostel.name,
                        colors: colors),
                    _SummaryRow(
                        label: 'Room Type', value: widget.room.roomType, colors: colors),
                    _SummaryRow(
                        label: 'Semester',
                        value: 'Sem 2, 2026',
                        colors: colors),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: 'Total',
                      value: Formatters.formatUGX(amount),
                      colors: colors,
                      isBold: true,
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 100.ms)
                  .slideY(begin: 0.06, end: 0),
  
              const SizedBox(height: 24),
  
              // ── Phone Number Input ──
              Text(
                'Mobile Money Number',
                style: AppTypography.titleMedium.copyWith(color: colors.textHigh),
              )
                  .animate()
                  .fadeIn(duration: 350.ms, delay: 250.ms),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: AppTypography.bodyMedium.copyWith(color: colors.textHigh),
                decoration: InputDecoration(
                  hintText: '+256 7...',
                  prefixIcon: Icon(Icons.phone_android_rounded, color: colors.textMid),
                  filled: true,
                  fillColor: colors.surfaceElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.orangeBright),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 350.ms, delay: 280.ms),
  
              const SizedBox(height: 24),
  
              // ── Payment method ──
              Text(
                AppStrings.paymentMethod,
                style:
                    AppTypography.titleMedium.copyWith(color: colors.textHigh),
              )
                  .animate()
                  .fadeIn(duration: 350.ms, delay: 320.ms),
              const SizedBox(height: 12),
  
              Row(
                children: [
                  Expanded(
                    child: _PaymentMethodTile(
                      name: AppStrings.mtnMobileMoney,
                      color: const Color(0xFFFFD600),
                      isSelected: _selectedMethod == 'MTN Mobile Money',
                      onTap: () =>
                          setState(() => _selectedMethod = 'MTN Mobile Money'),
                    )
                        .animate()
                        .fadeIn(duration: 350.ms, delay: 380.ms)
                        .slideX(begin: -0.04, end: 0),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PaymentMethodTile(
                      name: AppStrings.airtelMoney,
                      color: const Color(0xFFFF0000),
                      isSelected: _selectedMethod == 'Airtel Money',
                      onTap: () => setState(() => _selectedMethod = 'Airtel Money'),
                    )
                        .animate()
                        .fadeIn(duration: 350.ms, delay: 420.ms)
                        .slideX(begin: 0.04, end: 0),
                  ),
                ],
              ),
  
              const SizedBox(height: 40),
  
              // ── Pay Now ──
              GradientButton(
                onPressed: _showCheckout,
                text: '${AppStrings.payNow} — ${Formatters.formatUGXCompact(amount)}',
                width: double.infinity,
                icon: Icons.lock_rounded,
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 500.ms)
                  .slideY(begin: 0.1, end: 0),
  
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.colors,
    this.isBold = false,
  });

  final String label;
  final String value;
  final HostelHopColors colors;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: colors.textMid,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: (isBold
                      ? AppTypography.titleMedium
                      : AppTypography.bodyMedium)
                  .copyWith(
                color: colors.textHigh,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
              ),
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.name,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.orangeBright
                : theme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.orangeBright.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isSelected ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: AppTypography.titleSmall.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) => ScaleTransition(
                scale: anim,
                child: child,
              ),
              child: isSelected
                  ? const Icon(Icons.check_circle,
                      key: ValueKey('check'),
                      color: AppColors.orangeBright,
                      size: 22)
                  : const SizedBox(key: ValueKey('empty'), width: 22),
            ),
          ],
        ),
      ),
    );
  }
}
