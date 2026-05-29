import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import 'room_detail_screen.dart';

class RoomsListScreen extends StatelessWidget {
  const RoomsListScreen({super.key, required this.hostel});

  final Hostel hostel;

  @override
  Widget build(BuildContext context) {
    final colors = context.hhColors;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available Rooms', style: AppTypography.titleLarge.copyWith(color: colors.textHigh)),
            Text(hostel.name, style: AppTypography.bodySmall.copyWith(color: colors.textLow)),
          ],
        ),
      ),
      body: hostel.rooms.isEmpty
          ? _buildEmpty(colors)
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: hostel.rooms.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final room = hostel.rooms[index];
                return _RoomCard(room: room, colors: colors, index: index);
              },
            ),
    );
  }

  Widget _buildEmpty(HostelHopColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bed_rounded, size: 64, color: colors.textLow.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('No rooms available', style: AppTypography.titleMedium.copyWith(color: colors.textMid)),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({required this.room, required this.colors, required this.index});
  final Room room;
  final HostelHopColors colors;
  final int index;

  String _getOccupancyLabel() {
    if (room.currentOccupancy >= room.maxOccupancy) return 'Full';
    if (room.maxOccupancy == 1) return 'Available';
    if (room.maxOccupancy == 2 && room.currentOccupancy == 1) return 'Half-occupied';
    if (room.currentOccupancy == 0) return 'Available';
    return '${room.maxOccupancy - room.currentOccupancy} spots left';
  }

  Color _getLabelColor() {
    final label = _getOccupancyLabel();
    if (label == 'Full') return AppColors.error;
    if (label == 'Half-occupied') return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomDetailScreen(room: room),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.orangeBright.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.bed_rounded, color: AppColors.orangeBright),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Room ${room.roomNumber}',
                    style: AppTypography.titleSmall.copyWith(color: colors.textHigh, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${room.roomType} · ${room.maxOccupancy} Person',
                    style: AppTypography.bodySmall.copyWith(color: colors.textMid),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.formatUGX(room.pricePerSemester),
                  style: AppTypography.priceCompact.copyWith(color: colors.textHigh, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getLabelColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getOccupancyLabel(),
                    style: AppTypography.labelSmall.copyWith(color: _getLabelColor(), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
    .animate()
    .fadeIn(duration: 400.ms, delay: Duration(milliseconds: 50 * index))
    .slideX(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
  }
}
