import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/formatters.dart';
import '../data/models/models.dart';
import '../data/providers/data_providers.dart';
import '../features/auth/providers/auth_provider.dart';

/// Hostel listing card with tap scale animation.
class HostelCard extends StatefulWidget {
  const HostelCard({super.key, required this.hostel, this.onTap});

  final Hostel hostel;
  final VoidCallback? onTap;

  @override
  State<HostelCard> createState() => _HostelCardState();
}

class _HostelCardState extends State<HostelCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.hhColors;
    final theme = Theme.of(context);
    final hostel = widget.hostel;
    final tags = hostel.tags;

    return GestureDetector(
      onTapDown: (_) => _scaleCtrl.forward(),
      onTapUp: (_) {
        _scaleCtrl.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _scaleCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnim.value, child: child);
        },
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // ── Thumbnail ──
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 80,
                        height: 80,
                        color: colors.surfaceElevated,
                        child: hostel.images.isNotEmpty
                            ? Image.network(
                                hostel.images.first,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => _buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
                      ),
                    ),
                    // Trending badge
                    if (hostel.isTrending)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B35), Color(0xFFFF3D00)],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('🔥', style: TextStyle(fontSize: 8)),
                              SizedBox(width: 2),
                              Text(
                                'Trending',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 7,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Consumer(
                        builder: (context, ref, _) {
                          final savedIds = ref.watch(savedHostelsProvider);
                          final isSaved = savedIds.contains(hostel.id);
                          final isAuthenticated = ref.watch(isAuthenticatedProvider);

                          return GestureDetector(
                            onTap: () {
                              if (isAuthenticated) {
                                ref.read(savedHostelsProvider.notifier).toggle(hostel.id);
                              } else {
                                GoRouter.of(context).push('/login');
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                color: isSaved ? AppColors.orangeBright : Colors.white,
                                size: 14,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 14),

                // ── Info ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hostel.name,
                        style: AppTypography.titleSmall.copyWith(
                          color: colors.textHigh,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 12, color: AppColors.orangeBright),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              '${hostel.address} · ${hostel.distanceFromCampus ?? ''}',
                              style: AppTypography.bodySmall.copyWith(
                                color: colors.textMid, fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.bed_rounded,
                                    size: 12, color: AppColors.success),
                                const SizedBox(width: 4),
                                Text(
                                  '${hostel.availableRooms} rooms left',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.success,
                                    fontSize: 10, letterSpacing: 0.2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (tags.isNotEmpty)
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getTagColor(tags.first).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  tags.first,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: _getTagColor(tags.first),
                                    fontSize: 10, letterSpacing: 0.2),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Price ──
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Formatters.formatUGXCompact(hostel.startingPrice),
                      style: AppTypography.priceCompact
                          .copyWith(color: AppColors.orangeBright),
                    ),
                    Text(
                      '/semester',
                      style: AppTypography.bodySmall
                          .copyWith(color: colors.textLow, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.orangeBright.withValues(alpha: 0.1),
      child: const Icon(
        Icons.apartment_rounded, color: AppColors.orangeBright, size: 28),
    );
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'Selling Fast':
        return AppColors.warning;
      case 'AC':
        return AppColors.blueLight;
      default:
        return AppColors.orangeBright;
    }
  }
}
