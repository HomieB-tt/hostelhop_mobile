import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../data/mock/mock_data.dart';
import '../../data/providers/data_providers.dart';
import '../../widgets/sun_meter.dart';
import '../../widgets/hostel_card.dart';
import '../hostel_detail/hostel_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home screen with SliverPersistentHeader Sun Meter and hostel listings.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.hhColors;
    final hostelsAsync = ref.watch(hostelsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Collapsing header ──
          SliverPersistentHeader(
            pinned: true,
            delegate: _SunMeterHeaderDelegate(
              expandedHeight: 340,
              collapsedHeight: 100,
              topPadding: MediaQuery.of(context).padding.top,
            ),
          ),

          // ── Section title ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.availableHostels,
                    style: AppTypography.titleLarge.copyWith(
                      color: colors.textHigh,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      AppStrings.viewAll,
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.orangeBright,
                      ),
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 200.ms)
                  .slideY(begin: 0.06, end: 0, curve: Curves.easeOut),
            ),
          ),

          // ── Hostel listings with staggered animation ──
          hostelsAsync.when(
            data: (hostels) => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final hostel = hostels[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: HostelCard(
                      hostel: hostel,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                HostelDetailScreen(hostel: hostel),
                            transitionDuration: const Duration(milliseconds: 350),
                            reverseTransitionDuration:
                                const Duration(milliseconds: 250),
                            transitionsBuilder:
                                (context, animation, secondaryAnimation, child) {
                              final curved = CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              );
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(curved),
                                child:
                                    FadeTransition(opacity: curved, child: child),
                              );
                            },
                          ),
                        );
                      },
                    )
                        .animate()
                        .fadeIn(
                          duration: 400.ms,
                          delay: Duration(milliseconds: 300 + (index * 80)),
                        )
                        .slideY(
                          begin: 0.06,
                          end: 0,
                          delay: Duration(milliseconds: 300 + (index * 80)),
                          duration: 400.ms,
                          curve: Curves.easeOutCubic,
                        ),
                  );
                }, childCount: hostels.length),
              ),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(child: Text('Error loading hostels: $err')),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────
//  Collapsing Sun Meter Header
// ──────────────────────────────────────

class _SunMeterHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SunMeterHeaderDelegate({
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.topPadding,
  });

  final double expandedHeight;
  final double collapsedHeight;
  final double topPadding;

  @override
  double get maxExtent => expandedHeight + topPadding;

  @override
  double get minExtent => collapsedHeight + topPadding;

  @override
  bool shouldRebuild(covariant _SunMeterHeaderDelegate oldDelegate) => true;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.splashGradient,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24 * (1 - progress)),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Expanded content ──
          Opacity(
            opacity: (1 - progress * 2).clamp(0.0, 1.0),
            child: Padding(
              padding: EdgeInsets.only(
                top: topPadding + 16,
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting
                  Text(
                    'Good afternoon, Brian 🌞',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.findYourShade,
                    style: AppTypography.displayLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Search bar
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Icon(
                          Icons.search_rounded,
                          color: Colors.white.withValues(alpha: 0.7),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            AppStrings.searchHint,
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.tune_rounded,
                            color: Colors.white.withValues(alpha: 0.8),
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Sun Meter
                  const SunMeter(),
                ],
              ),
            ),
          ),

          // ── Collapsed content ──
          Opacity(
            opacity: (progress * 2 - 1).clamp(0.0, 1.0),
            child: Padding(
              padding: EdgeInsets.only(
                top: topPadding + 12,
                left: 20,
                right: 20,
              ),
              child: Row(
                children: [
                  const Text('☀️', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Text(
                    '${MockData.weatherTemp}°C',
                    style: AppTypography.titleLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '· ${MockData.weatherLocation}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
