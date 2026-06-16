import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../data/providers/data_providers.dart';
import '../../widgets/hostel_card.dart';
import '../hostel_detail/hostel_detail_screen.dart';

/// Full scrollable list of all hostels, sorted trending-first.
class AllHostelsScreen extends ConsumerWidget {
  const AllHostelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.hhColors;
    final hostelsAsync = ref.watch(hostelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Hostels',
          style: AppTypography.titleLarge.copyWith(color: colors.textHigh),
        ),
      ),
      body: hostelsAsync.when(
        data: (hostels) {
          final filtered = hostels.where((h) => h.isOnline).toList();

          // Sort: trending first (by viewCount desc), then alphabetical
          filtered.sort((a, b) {
            if (a.isTrending && !b.isTrending) return -1;
            if (!a.isTrending && b.isTrending) return 1;
            if (a.isTrending && b.isTrending) return b.viewCount.compareTo(a.viewCount);
            return a.name.compareTo(b.name);
          });

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.apartment_rounded, size: 64, color: colors.textLow.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(
                    'No hostels available',
                    style: AppTypography.titleMedium.copyWith(color: colors.textMid),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(hostelsProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final hostel = filtered[index];
                return HostelCard(
                  hostel: hostel,
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            HostelDetailScreen(hostel: hostel),
                        transitionDuration: const Duration(milliseconds: 350),
                        reverseTransitionDuration: const Duration(milliseconds: 250),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          final curved = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          );
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(curved),
                            child: FadeTransition(opacity: curved, child: child),
                          );
                        },
                      ),
                    );
                  },
                )
                    .animate()
                    .fadeIn(
                      duration: 400.ms,
                      delay: Duration(milliseconds: 50 + (index * 60)),
                    )
                    .slideY(
                      begin: 0.06,
                      end: 0,
                      delay: Duration(milliseconds: 50 + (index * 60)),
                      duration: 400.ms,
                      curve: Curves.easeOutCubic,
                    );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error loading hostels: $err'),
        ),
      ),
    );
  }
}
