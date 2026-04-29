import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../widgets/gradient_button.dart';
import 'checkout_sheet.dart';

/// Payment screen — select method and initiate payment.
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.hostel});

  final Hostel hostel;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'MTN Mobile Money';

  void _showCheckout() {
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
        paymentMethod: _selectedMethod,
        amount: widget.hostel.startingPrice,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.hhColors;
    final theme = Theme.of(context);
    final amount = widget.hostel.startingPrice;

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
      body: Padding(
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
                      label: 'Room Type', value: 'Double', colors: colors),
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

            // ── Payment method ──
            Text(
              AppStrings.paymentMethod,
              style:
                  AppTypography.titleMedium.copyWith(color: colors.textHigh),
            )
                .animate()
                .fadeIn(duration: 350.ms, delay: 250.ms),
            const SizedBox(height: 12),

            _PaymentMethodTile(
              name: AppStrings.mtnMobileMoney,
              color: const Color(0xFFFFD600),
              isSelected: _selectedMethod == 'MTN Mobile Money',
              onTap: () =>
                  setState(() => _selectedMethod = 'MTN Mobile Money'),
            )
                .animate()
                .fadeIn(duration: 350.ms, delay: 320.ms)
                .slideX(begin: -0.04, end: 0),

            const SizedBox(height: 10),

            _PaymentMethodTile(
              name: AppStrings.airtelMoney,
              color: const Color(0xFFFF0000),
              isSelected: _selectedMethod == 'Airtel Money',
              onTap: () => setState(() => _selectedMethod = 'Airtel Money'),
            )
                .animate()
                .fadeIn(duration: 350.ms, delay: 400.ms)
                .slideX(begin: -0.04, end: 0),

            const Spacer(),

            // ── Pay Now ──
            GradientButton(
              onPressed: _showCheckout,
              text: '${AppStrings.payNow} — ${Formatters.formatUGX(amount)}',
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: colors.textMid,
            ),
          ),
          Text(
            value,
            style: (isBold
                    ? AppTypography.titleMedium
                    : AppTypography.bodyMedium)
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
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                name,
                style: AppTypography.titleSmall.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
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
