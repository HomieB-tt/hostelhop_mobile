import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart'; // Import for SystemNavigator

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../data/providers/data_providers.dart';
import '../../widgets/sun_meter.dart';
import '../../widgets/hostel_card.dart';
import '../../widgets/search_input.dart';
import '../hostel_detail/hostel_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../providers/weather_provider.dart';
import '../../data/models/models.dart';

/// Home screen with SliverPersistentHeader and hostel listings.
///
/// The orange gradient header contains only the greeting, title, and search bar.
/// The Sun Meter sits below it on the regular page background as a standalone card.
/// On scroll, the header collapses to show only temperature and location.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime? _lastPressedAt; // To track the last back button press time

  @override
  Widget build(BuildContext context) {
    final colors = context.hhColors;
    final hostelsAsync = ref.watch(hostelsProvider);
    final user = ref.watch(currentUserProvider);
    final weatherAsync = ref.watch(weatherProvider);
    final String fullName =
        user?.userMetadata?['full_name'] as String? ?? 'Student';
    final String firstName = fullName.split(' ').first;

    final screenHeight = MediaQuery.of(context).size.height;
    final paddingTop = MediaQuery.of(context).padding.top;
    final usableHeight = screenHeight - paddingTop;

    // Use responsive heights
    final headerExpandedHeight = 150.0;
    final sunMeterExpandedHeight = usableHeight * 0.25;

    return PopScope( // Changed WillPopScope to PopScope as WillPopScope is deprecated
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        final now = DateTime.now();
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;
          SnackBarUtils.show(context, 'Tap back again to exit', duration: const Duration(seconds: 2));
          return;
        }
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(hostelsProvider);
            ref.invalidate(weatherProvider);
          },
          child: CustomScrollView(
            slivers: [
              // ── Compact collapsing orange header ──
              SliverPersistentHeader(
                pinned: true,
                delegate: _CompactHeaderDelegate(
                  expandedHeight: headerExpandedHeight,
                  collapsedHeight: 56,
                  topPadding: paddingTop,
                  firstName: firstName,
                  weatherAsync: weatherAsync,
                  onSearchTap: () {
                    context.go('/search');
                  },
                ),
              ),

              // ── Sun Meter card with persistent header property ──
              SliverPersistentHeader(
                pinned: true,
                delegate: _SunMeterDelegate(
                  expandedHeight: sunMeterExpandedHeight,
                  collapsedHeight: 60,
                  weatherAsync: weatherAsync,
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
                data: (hostels) {
                  final filteredHostels = hostels
                      .where((h) => h.isOnline)
                      .toList();

                  if (filteredHostels.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'No hostels found',
                          style: AppTypography.bodyLarge
                              .copyWith(color: colors.textMid),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final hostel = filteredHostels[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: HostelCard(
                              hostel: hostel,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        HostelDetailScreen(hostel: hostel),
                                    transitionDuration:
                                        const Duration(milliseconds: 350),
                                    reverseTransitionDuration:
                                        const Duration(milliseconds: 250),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      final curved = CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      );
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1, 0),
                                          end: Offset.zero,
                                        ).animate(curved),
                                        child: FadeTransition(
                                            opacity: curved, child: child),
                                      );
                                    },
                                  ),
                                );
                              },
                            )
                                .animate()
                                .fadeIn(
                                  duration: 400.ms,
                                  delay:
                                      Duration(milliseconds: 300 + (index * 80)),
                                )
                                .slideY(
                                  begin: 0.06,
                                  end: 0,
                                  delay:
                                      Duration(milliseconds: 300 + (index * 80)),
                                  duration: 400.ms,
                                  curve: Curves.easeOutCubic,
                                ),
                          );
                        },
                        childCount: filteredHostels.length,
                      ),
                    ),
                  );
                },
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
        ),
      ),
    );
  }
}

// ──────────────────────────────────────
//  Compact Collapsing Header
// ──────────────────────────────────────

class _CompactHeaderDelegate extends SliverPersistentHeaderDelegate {
  _CompactHeaderDelegate({
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.topPadding,
    required this.firstName,
    required this.weatherAsync,
    required this.onSearchTap,
  });

  final double expandedHeight;
  final double collapsedHeight;
  final double topPadding;
  final String firstName;
  final AsyncValue<WeatherInfo?> weatherAsync;
  final VoidCallback onSearchTap;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  double get maxExtent => expandedHeight + topPadding;

  @override
  double get minExtent => collapsedHeight + topPadding;

  @override
  bool shouldRebuild(covariant _CompactHeaderDelegate oldDelegate) => true;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: AppColors.splashGradient,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20 * (1 - progress)),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Expanded content: greeting + title + search bar ──
          Opacity(
            opacity: (1 - progress * 2.5).clamp(0.0, 1.0),
            child: Padding(
              padding: EdgeInsets.only(
                top: topPadding + 12,
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting
                  Center(
                    child: Text(
                      '${_getGreeting()}, $firstName 🌞',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Center(
                    child: Text(
                      AppStrings.findYourShade,
                      style: AppTypography.headlineLarge.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Search bar
                  SearchInput(
                    readOnly: true,
                    onTap: onSearchTap,
                  ),
                ],
              ),
            ),
          ),

          // ── Collapsed content: greeting + username ──
          Opacity(
            opacity: (progress * 2 - 1).clamp(0.0, 1.0),
            child: Padding(
              padding: EdgeInsets.only(
                top: topPadding + 14,
                left: 20,
                right: 20,
              ),
              child: Row(
                children: [
                  const Text('👋', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    '${_getGreeting()}, $firstName',
                    style: AppTypography.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onSearchTap,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.search_rounded,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 18,
                      ),
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

class _SunMeterDelegate extends SliverPersistentHeaderDelegate {
  _SunMeterDelegate({
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.weatherAsync,
  });

  final double expandedHeight;
  final double collapsedHeight;
  final AsyncValue<dynamic> weatherAsync;

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => collapsedHeight;

  @override
  bool shouldRebuild(covariant _SunMeterDelegate oldDelegate) {
    return expandedHeight != oldDelegate.expandedHeight ||
        collapsedHeight != oldDelegate.collapsedHeight ||
        weatherAsync != oldDelegate.weatherAsync;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / (maxExtent - minExtent);
    final clampedProgress = progress.clamp(0.0, 1.0);

    final colors = context.hhColors;

    return ClipRect(
      child: Container(
        color: colors.background,
        child: Stack(
          children: [
            // Expanded Sun Meter
            IgnorePointer(
              ignoring: clampedProgress > 0.5,
              child: Opacity(
                opacity: 1.0 - clampedProgress,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: const SunMeter(),
                ),
              ),
            ),

          // Collapsed state
          if (clampedProgress > 0.5)
            Opacity(
              opacity: (clampedProgress - 0.5) * 2,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: weatherAsync.when(
                      data: (weather) {
                        final temp = weather?.temperature.toInt() ?? 27;
                        final loc = weather?.location ?? 'Kampala';
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on_rounded, size: 16, color: AppColors.orangeBright),
                                const SizedBox(width: 6),
                                Text(
                                  loc,
                                  style: AppTypography.titleSmall.copyWith(color: colors.textHigh),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '$temp°C',
                                  style: AppTypography.titleSmall.copyWith(color: AppColors.orangeBright, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.wb_sunny_rounded, size: 16, color: AppColors.orangeBright),
                              ],
                            ),
                          ],
                        );
                      },
                      loading: () => const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))),
                      error: (err, stack) => const SizedBox(),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
     ),
    );
  }
}
