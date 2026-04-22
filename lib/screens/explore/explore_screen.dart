import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';

/// Explore tab — placeholder for full hostel search/filter.
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.hhColors;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.navExplore,
          style: AppTypography.titleLarge.copyWith(color: colors.textHigh),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore_outlined,
              size: 64,
              color: colors.textLow.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Explore Hostels',
              style: AppTypography.titleMedium.copyWith(color: colors.textMid),
            ),
            const SizedBox(height: 8),
            Text(
              'Search and filter all available hostels',
              style: AppTypography.bodySmall.copyWith(color: colors.textLow),
            ),
          ],
        ),
      ),
    );
  }
}
