import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../widgets/gradient_button.dart';
import '../payment/payment_screen.dart';

/// Hostel detail screen showing full info, amenities, availability, and pricing.
class HostelDetailScreen extends StatelessWidget {
  const HostelDetailScreen({super.key, required this.hostel});

  final Hostel hostel;

  @override
  Widget build(BuildContext context) {
    final colors = context.hhColors;
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // ── Header image ──
                SliverAppBar(
                  expandedHeight: 220,
                  pinned: true,
                  backgroundColor: AppColors.orangeBright,
                  leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  actions: [
                    // Rooms left badge
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '🏠 ${hostel.availableRooms} Rooms Left!',
                        style: AppTypography.labelMedium.copyWith(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.orangeBright.withValues(alpha: 0.3),
                            AppColors.orangePrimary.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                      child: hostel.images.isNotEmpty
                          ? Image.network(
                              hostel.images.first,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  _buildImagePlaceholder(),
                            )
                          : _buildImagePlaceholder(),
                    ),
                  ),
                ),

                // ── Content ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        Text(
                          hostel.name,
                          style: AppTypography.headlineMedium.copyWith(
                            color: colors.textHigh,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Address
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: AppColors.orangeBright,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${hostel.address} · ${hostel.distanceFromCampus ?? ''}',
                                style: AppTypography.bodySmall.copyWith(
                                  color: colors.textMid,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Rating
                        if (hostel.rating != null)
                          Row(
                            children: [
                              Text(
                                hostel.rating!.toString(),
                                style: AppTypography.titleMedium.copyWith(
                                  color: AppColors.orangeBright,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 4),
                              ...List.generate(5, (i) {
                                return Icon(
                                  i < hostel.rating!.floor()
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  size: 16,
                                  color: AppColors.orangeBright,
                                );
                              }),
                              const SizedBox(width: 6),
                              Text(
                                '(${hostel.reviewCount} ${AppStrings.reviews})',
                                style: AppTypography.bodySmall.copyWith(
                                  color: colors.textLow,
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 24),

                        // Amenities
                        Text(
                          AppStrings.amenities,
                          style: AppTypography.titleMedium.copyWith(
                            color: colors.textHigh,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: hostel.amenities.map((a) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                              child: Text(
                                a,
                                style: AppTypography.labelMedium.copyWith(
                                  color: colors.textMid,
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 24),

                        // Room availability
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colors.surfaceElevated,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              // Number
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${hostel.availableRooms}',
                                    style: AppTypography.displayLarge.copyWith(
                                      color: AppColors.orangeBright,
                                      fontSize: 40,
                                    ),
                                  ),
                                  Text(
                                    AppStrings.roomsRemaining,
                                    style: AppTypography.labelMedium.copyWith(
                                      color: colors.textMid,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 20),

                              // Progress bar
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: LinearProgressIndicator(
                                        value: hostel.totalRooms > 0
                                            ? (hostel.totalRooms -
                                                      hostel.availableRooms) /
                                                  hostel.totalRooms
                                            : 0,
                                        backgroundColor: theme
                                            .colorScheme
                                            .outline
                                            .withValues(alpha: 0.2),
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                              AppColors.orangeBright,
                                            ),
                                        minHeight: 8,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${hostel.totalRooms - hostel.availableRooms} of ${hostel.totalRooms} rooms left',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: colors.textLow,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Description
                        if (hostel.description.isNotEmpty)
                          Text(
                            hostel.description,
                            style: AppTypography.bodyMedium.copyWith(
                              color: colors.textMid,
                              height: 1.6,
                            ),
                          ),

                        const SizedBox(height: 24),

                        // Price
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.orangeBright.withValues(
                              alpha: 0.06,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.orangeBright.withValues(
                                alpha: 0.15,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    Formatters.formatUGX(hostel.startingPrice),
                                    style: AppTypography.priceTag.copyWith(
                                      color: colors.textHigh,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '/semester',
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: colors.textLow,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${AppStrings.commitmentFee}: ${Formatters.formatUGX((hostel.startingPrice * 0.65).round())}',
                                style: AppTypography.bodySmall.copyWith(
                                  color: colors.textMid,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Lock My Room CTA ──
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: GradientButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentScreen(hostel: hostel),
                    ),
                  );
                },
                text: AppStrings.lockMyRoom,
                width: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.orangeBright.withValues(alpha: 0.2),
      child: const Center(
        child: Icon(Icons.apartment_rounded, size: 64, color: Colors.white),
      ),
    );
  }
}
