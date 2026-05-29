import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../widgets/gradient_button.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({
    super.key,
    required this.booking,
    required this.payment,
  });

  final Booking booking;
  final Payment payment;

  @override
  Widget build(BuildContext context) {
    final colors = context.hhColors;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmed'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Success Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.successSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, size: 48, color: AppColors.success),
            ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
            
            const SizedBox(height: 24),
            
            Text(
              'Thank You!',
              style: AppTypography.headlineMedium.copyWith(color: colors.textHigh),
            ),
            const SizedBox(height: 8),
            Text(
              'Your booking is confirmed. Please show this screen to the custodian upon arrival.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(color: colors.textMid),
            ),
            
            const SizedBox(height: 32),
            
            // Booking Details Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BOOKING DETAILS', style: AppTypography.labelSmall.copyWith(color: colors.textLow, letterSpacing: 1.2)),
                  const SizedBox(height: 16),
                  _row('Hostel', booking.hostelName, colors),
                  _row('Room Number', booking.roomNumber, colors),
                  _row('Room Type', booking.roomType, colors),
                  _row('Check-in', Formatters.formatDate(booking.checkInDate), colors),
                  const SizedBox(height: 16),
                  Divider(color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  Text('PAYMENT DETAILS', style: AppTypography.labelSmall.copyWith(color: colors.textLow, letterSpacing: 1.2)),
                  const SizedBox(height: 16),
                  _row('Transaction ID', payment.transactionId, colors),
                  _row('Amount Paid', Formatters.formatUGX(payment.amount), colors),
                  _row('Status', 'PAID', colors, valueColor: AppColors.success),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),
            
            const SizedBox(height: 32),
            
            GradientButton(
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              text: 'Done',
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, HostelHopColors colors, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall.copyWith(color: colors.textMid)),
          Text(value, style: AppTypography.bodyMedium.copyWith(color: valueColor ?? colors.textHigh, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
