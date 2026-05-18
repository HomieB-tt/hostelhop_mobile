import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/formatters.dart';
import '../data/models/models.dart';

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 64,
                    height: 64,
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
                                  color: tags.first == 'Selling Fast'
                                      ? AppColors.error.withValues(alpha: 0.1)
                                      : colors.brandSoft,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  tags.first,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: tags.first == 'Selling Fast'
                                        ? AppColors.error
                                        : AppColors.orangeBright,
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
                          .copyWith(color: colors.textHigh),
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
}
