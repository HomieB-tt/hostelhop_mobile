import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/providers/data_providers.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../widgets/gradient_button.dart';
import '../hostel_detail/hostel_detail_screen.dart';
import '../hostel_detail/room_detail_screen.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.hhColors;
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.myBookings,
              style: AppTypography.titleLarge.copyWith(color: colors.textHigh)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_outlined, size: 64,
                    color: colors.textLow.withValues(alpha: 0.4))
                    .animate().fadeIn(duration: 400.ms)
                    .scaleXY(begin: 0.8, end: 1, curve: Curves.easeOutBack),
                const SizedBox(height: 16),
                Text('Login to view your bookings',
                    style: AppTypography.titleMedium.copyWith(color: colors.textHigh))
                    .animate().fadeIn(duration: 350.ms, delay: 150.ms),
                const SizedBox(height: 8),
                Text(
                    'Sign in to see your booking history and manage reservations',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall.copyWith(color: colors.textLow))
                    .animate().fadeIn(duration: 350.ms, delay: 250.ms),
                const SizedBox(height: 24),
                GradientButton(
                  text: 'Login / Sign Up',
                  onPressed: () => GoRouter.of(context).push('/login'),
                ).animate().fadeIn(duration: 350.ms, delay: 350.ms),
              ],
            ),
          ),
        ),
      );
    }

    final bookingsAsync = ref.watch(myBookingsProvider);
    final savedHostelIds = ref.watch(savedHostelsProvider);
    final savedRoomIds = ref.watch(savedRoomsProvider);
    final hostelsAsync = ref.watch(hostelsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.myBookings,
              style: AppTypography.titleLarge.copyWith(color: colors.textHigh)),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Saved'),
              Tab(text: 'Completed'),
            ],
            labelColor: AppColors.orangeBright,
            unselectedLabelColor: colors.textLow,
            indicatorColor: AppColors.orangeBright,
            labelStyle: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
            unselectedLabelStyle: AppTypography.titleSmall,
          ),
        ),
        body: TabBarView(
          children: [
            // Saved Tab
            hostelsAsync.when(
              data: (hostels) {
                // Collect saved items (Hostel or Hostel+Room)
                final savedItems = <({Hostel hostel, Room? room})>[];
                
                for (final h in hostels) {
                  final savedRoomsInHostel = h.rooms.where((r) => savedRoomIds.contains(r.id)).toList();
                  if (savedRoomsInHostel.isNotEmpty) {
                    for (final r in savedRoomsInHostel) {
                      savedItems.add((hostel: h, room: r));
                    }
                  } else if (savedHostelIds.contains(h.id)) {
                    savedItems.add((hostel: h, room: null));
                  }
                }

                return savedItems.isEmpty
                    ? _buildEmptySaved(colors)
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: savedItems.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = savedItems[index];
                          return _SavedHostelCard(
                            hostel: item.hostel, 
                            room: item.room,
                            colors: colors, 
                            index: index
                          );
                        },
                      );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),

            // Completed Tab
            bookingsAsync.when(
              data: (bookings) {
                final completedBookings = bookings.where((b) => b.status == 'paid' || b.status == 'approved').toList();
                return completedBookings.isEmpty
                    ? _buildEmpty(colors)
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: completedBookings.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final b = completedBookings[index];
                          return _BookingCard(booking: b, colors: colors, index: index);
                        },
                      );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildError(colors, ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySaved(HostelHopColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border_rounded, size: 64,
              color: colors.textLow.withValues(alpha: 0.4))
              .animate().fadeIn(duration: 400.ms)
              .scaleXY(begin: 0.8, end: 1, curve: Curves.easeOutBack),
          const SizedBox(height: 16),
          Text('No saved hostels',
              style: AppTypography.titleMedium.copyWith(color: colors.textMid))
              .animate().fadeIn(duration: 350.ms, delay: 150.ms),
          const SizedBox(height: 8),
          Text('Hostels you save will appear here',
              style: AppTypography.bodySmall.copyWith(color: colors.textLow))
              .animate().fadeIn(duration: 350.ms, delay: 250.ms),
        ],
      ),
    );
  }

  Widget _buildError(HostelHopColors colors, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded, size: 56,
                color: colors.textLow.withValues(alpha: 0.4))
                .animate().fadeIn(duration: 400.ms)
                .scaleXY(begin: 0.8, end: 1, curve: Curves.easeOutBack),
            const SizedBox(height: 16),
            Text('Couldn\'t load bookings',
                style: AppTypography.titleMedium.copyWith(color: colors.textMid))
                .animate().fadeIn(duration: 350.ms, delay: 100.ms),
            const SizedBox(height: 8),
            Text('Pull down to refresh or try again later',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(color: colors.textLow))
                .animate().fadeIn(duration: 350.ms, delay: 200.ms),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () => ref.invalidate(myBookingsProvider),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
              style: TextButton.styleFrom(foregroundColor: AppColors.orangeBright),
            ).animate().fadeIn(duration: 350.ms, delay: 300.ms),
          ],
        ),
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

class _SavedHostelCard extends StatelessWidget {
  const _SavedHostelCard({required this.hostel, this.room, required this.colors, required this.index});
  final Hostel hostel;
  final Room? room;
  final HostelHopColors colors;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (room != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomDetailScreen(room: room!, hostel: hostel),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HostelDetailScreen(hostel: hostel),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: hostel.images.isNotEmpty
                    ? Image.network(hostel.images.first, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (_, _, _) => _buildPlaceholder())
                    : _buildPlaceholder(),
                ),
                if (room != null)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.orangeBright,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomRight: Radius.circular(12)),
                      ),
                      child: const Icon(Icons.bed_rounded, size: 12, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hostel.name, style: AppTypography.titleSmall.copyWith(color: colors.textHigh, fontWeight: FontWeight.bold)),
                  if (room != null) ...[
                    const SizedBox(height: 2),
                    Text('${room!.roomType}${room!.roomNumber.isNotEmpty ? ' · Room ${room!.roomNumber}' : ''}', 
                      style: AppTypography.bodySmall.copyWith(color: AppColors.orangeBright, fontWeight: FontWeight.w600, fontSize: 12)),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 12, color: colors.textLow),
                      const SizedBox(width: 4),
                      Text(hostel.address, style: AppTypography.bodySmall.copyWith(color: colors.textMid, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    room != null 
                      ? Formatters.formatUGX(room!.pricePerSemester)
                      : 'From ${Formatters.formatUGX(hostel.startingPrice)}', 
                    style: AppTypography.priceCompact.copyWith(color: colors.textHigh, fontSize: 13)
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.textLow),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideX(begin: 0.1, end: 0);
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      color: AppColors.orangeBright.withValues(alpha: 0.1),
      child: const Icon(Icons.apartment_rounded, color: AppColors.orangeBright),
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
            children: [
              Expanded(
                child: Text(booking.hostelName,
                    style: AppTypography.titleSmall
                        .copyWith(color: colors.textHigh, fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 8),
              _StatusBadge(status: booking.status),
            ],
          ),
          const SizedBox(height: 8),
          Row(children: [
            Icon(Icons.bed_rounded, size: 14, color: colors.textLow),
            const SizedBox(width: 6),
            Text(
                booking.roomNumber.isNotEmpty
                    ? '${booking.roomType} · Room ${booking.roomNumber}'
                    : booking.roomType,
                style: AppTypography.bodySmall.copyWith(color: colors.textMid)),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            Icon(Icons.calendar_today_rounded, size: 14, color: colors.textLow),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '${Formatters.formatDate(booking.checkInDate)} — ${Formatters.formatDate(booking.checkOutDate)}',
                style: AppTypography.bodySmall.copyWith(color: colors.textMid, fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rent Paid', style: AppTypography.bodySmall.copyWith(color: colors.textLow, fontSize: 10)),
                  Text(Formatters.formatUGX(booking.amount),
                      style: AppTypography.priceCompact.copyWith(color: colors.textHigh)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Transaction ID', style: AppTypography.bodySmall.copyWith(color: colors.textLow, fontSize: 10)),
                  Text(booking.id.length > 8 ? booking.id.substring(0, 8).toUpperCase() : booking.id.toUpperCase(),
                      style: AppTypography.labelSmall.copyWith(color: colors.textMid, fontFamily: 'monospace')),
                ],
              ),
            ],
          ),
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
