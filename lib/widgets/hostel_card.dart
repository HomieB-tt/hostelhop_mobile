import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/formatters.dart';
import '../data/models/models.dart';

/// Hostel listing card shown on the home screen.
///
/// Displays hostel thumbnail, name, location, available rooms,
/// badges (Selling Fast, AC), and starting price.
class HostelCard extends StatelessWidget {
  const HostelCard({
    super.key,
    required this.hostel,
    this.onTap,
  });

  final Hostel hostel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.hhColors;
    final theme = Theme.of(context);
    final tags = hostel.tags;

    return GestureDetector(
      onTap: onTap,
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
                        Icon(Icons.location_on,
                            size: 12, color: AppColors.orangeBright),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '${hostel.address} · ${hostel.distanceFromCampus ?? ''}',
                            style: AppTypography.bodySmall.copyWith(
                              color: colors.textMid,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Tags row
                    Row(
                      children: [
                        // Rooms left
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
                              Icon(Icons.bed_rounded,
                                  size: 12, color: AppColors.success),
                              const SizedBox(width: 4),
                              Text(
                                '${hostel.availableRooms} rooms left',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.success,
                                  fontSize: 10,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 6),

                        // Extra tags
                        ...tags.map((tag) => Container(
                              margin: const EdgeInsets.only(right: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: tag == 'Selling Fast'
                                    ? AppColors.error.withValues(alpha: 0.1)
                                    : colors.brandSoft,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                tag,
                                style: AppTypography.labelSmall.copyWith(
                                  color: tag == 'Selling Fast'
                                      ? AppColors.error
                                      : AppColors.orangeBright,
                                  fontSize: 10,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            )),
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
                    style: AppTypography.priceCompact.copyWith(
                      color: colors.textHigh,
                    ),
                  ),
                  Text(
                    '/semester',
                    style: AppTypography.bodySmall.copyWith(
                      color: colors.textLow,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.orangeBright.withValues(alpha: 0.1),
      child: const Icon(
        Icons.apartment_rounded,
        color: AppColors.orangeBright,
        size: 28,
      ),
    );
  }
}
