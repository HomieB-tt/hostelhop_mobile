import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../widgets/gradient_button.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../payment/checkout_sheet.dart';
import '../../data/providers/data_providers.dart';

class RoomDetailScreen extends ConsumerWidget {
  const RoomDetailScreen({super.key, required this.room, this.hostel});

  final Room room;
  final Hostel? hostel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.hhColors;
    final theme = Theme.of(context);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final hostelsAsync = ref.watch(hostelsProvider);

    Hostel? hostel = this.hostel;
    if (hostel == null) {
      hostelsAsync.whenData((hostels) {
        try {
          hostel = hostels.firstWhere((h) => h.id == room.hostelId);
        } catch (_) {
          hostel = null;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Room Details', style: AppTypography.titleLarge.copyWith(color: colors.textHigh)),
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final savedIds = ref.watch(savedRoomsProvider);
              final isSaved = savedIds.contains(room.id);
              final isAuthenticated = ref.watch(isAuthenticatedProvider);
              
              return IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isSaved ? AppColors.orangeBright : colors.textMid,
                ),
                onPressed: () {
                  if (isAuthenticated) {
                    ref.read(savedRoomsProvider.notifier).toggle(room.id);
                  } else {
                    context.push('/login');
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Placeholder
            Container(
              height: 250,
              width: double.infinity,
              color: AppColors.orangeBright.withValues(alpha: 0.1),
              child: const Icon(Icons.bed_rounded, size: 100, color: AppColors.orangeBright),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Room ${room.roomNumber}',
                        style: AppTypography.headlineSmall.copyWith(color: colors.textHigh, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        Formatters.formatUGX(room.pricePerSemester),
                        style: AppTypography.headlineSmall.copyWith(color: AppColors.orangeBright, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'per semester',
                    style: AppTypography.bodySmall.copyWith(color: colors.textLow),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _infoItem(Icons.category_outlined, 'Room Type', room.roomType, colors),
                  _infoItem(Icons.people_outline, 'Max Occupancy', '${room.maxOccupancy} Person', colors),
                  _infoItem(Icons.person_outline, 'Current Occupancy', '${room.currentOccupancy} occupied', colors),
                  
                  const SizedBox(height: 32),
                  
                  Text(
                    'Description',
                    style: AppTypography.titleMedium.copyWith(color: colors.textHigh, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This ${room.roomType.toLowerCase()} room is located in ${hostel?.name ?? 'the hostel'}. It offers a comfortable living space with essential amenities for students.',
                    style: AppTypography.bodyMedium.copyWith(color: colors.textMid, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(top: BorderSide(color: colors.border.withValues(alpha: 0.3))),
        ),
        child: SafeArea(
          child: GradientButton(
            onPressed: () {
              if (isAuthenticated) {
                if (hostel != null) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => CheckoutSheet(
                      hostel: hostel!,
                      room: room,
                      paymentMethod: 'MTN Mobile Money', // Default
                      phoneNumber: '0700000000', // Placeholder, should be user's phone
                    ),
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: Text('Authentication Required', 
                      style: AppTypography.titleMedium.copyWith(color: colors.textHigh, fontWeight: FontWeight.bold)),
                    content: Text('Please login or create an account to book this room.',
                      style: AppTypography.bodyMedium.copyWith(color: colors.textMid)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel', style: TextStyle(color: colors.textLow)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.push('/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orangeBright,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Login'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.push('/signup');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: AppColors.orangeBright,
                          elevation: 0,
                          side: BorderSide(color: AppColors.orangeBright),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                );
              }
            },
            text: 'Book Now',
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value, HostelHopColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.orangeBright.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppColors.orangeBright),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.labelSmall.copyWith(color: colors.textLow)),
              Text(value, style: AppTypography.bodyMedium.copyWith(color: colors.textHigh, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
