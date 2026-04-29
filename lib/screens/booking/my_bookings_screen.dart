import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock/mock_data.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.hhColors;
    final bookings = MockData.bookings;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.myBookings,
            style: AppTypography.titleLarge.copyWith(color: colors.textHigh)),
      ),
      body: bookings.isEmpty
          ? _buildEmpty(colors)
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: bookings.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final b = bookings[index];
                return _BookingCard(booking: b, colors: colors, index: index);
              },
            ),
    );
  }

  Widget _buildEmpty(HostelHopColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined, size: 64,
              color: colors.textLow.withValues(alpha: 0.4))
              .animate().fadeIn(duration: 400.ms)
              .scaleXY(begin: 0.8, end: 1, curve: Curves.easeOutBack),
          const SizedBox(height: 16),
          Text(AppStrings.noBookings,
              style: AppTypography.titleMedium.copyWith(color: colors.textMid))
              .animate().fadeIn(duration: 350.ms, delay: 150.ms),
          const SizedBox(height: 8),
          Text(AppStrings.noBookingsSubtitle,
              style: AppTypography.bodySmall.copyWith(color: colors.textLow))
              .animate().fadeIn(duration: 350.ms, delay: 250.ms),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking, required this.colors, required this.index});
  final dynamic booking;
  final HostelHopColors colors;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(booking.hostelName,
                  style: AppTypography.titleSmall
                      .copyWith(color: colors.textHigh, fontWeight: FontWeight.w700)),
              _StatusBadge(status: booking.status),
            ],
          ),
          const SizedBox(height: 8),
          Row(children: [
            Icon(Icons.bed_rounded, size: 14, color: colors.textLow),
            const SizedBox(width: 6),
            Text('${booking.roomType} · Room ${booking.roomNumber}',
                style: AppTypography.bodySmall.copyWith(color: colors.textMid)),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            Icon(Icons.calendar_today_rounded, size: 14, color: colors.textLow),
            const SizedBox(width: 6),
            Text(
              '${Formatters.formatDate(booking.checkInDate)} — ${Formatters.formatDate(booking.checkOutDate)}',
              style: AppTypography.bodySmall.copyWith(color: colors.textMid, fontSize: 11),
            ),
          ]),
          const SizedBox(height: 8),
          Text(Formatters.formatUGX(booking.amount),
              style: AppTypography.priceCompact.copyWith(color: colors.textHigh)),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: Duration(milliseconds: 100 + (index * 100)))
        .slideY(begin: 0.06, end: 0, delay: Duration(milliseconds: 100 + (index * 100)),
            duration: 400.ms, curve: Curves.easeOutCubic);
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (status) {
      'paid' => (AppColors.successSoft, AppColors.success),
      'approved' => (AppColors.orangeBright.withValues(alpha: 0.1), AppColors.orangeBright),
      'pending' => (AppColors.warningSoft, AppColors.warning),
      'rejected' || 'cancelled' => (AppColors.errorSoft, AppColors.error),
      _ => (Colors.grey.withValues(alpha: 0.1), Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(status[0].toUpperCase() + status.substring(1),
          style: AppTypography.labelSmall.copyWith(color: fg, fontSize: 10)),
    );
  }
}
