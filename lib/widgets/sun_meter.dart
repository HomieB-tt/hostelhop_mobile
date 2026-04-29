import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/constants/app_strings.dart';
import '../data/mock/mock_data.dart';

/// Sun Meter — weather gauge widget for the home screen header.
///
/// Shows temperature, feels-like, gradient bar with position indicator,
/// and a Luganda tip.
class SunMeter extends StatelessWidget {
  const SunMeter({super.key});

  @override
  Widget build(BuildContext context) {
    final temp = MockData.weatherTemp;
    final feelsLike = MockData.weatherFeelsLike;
    final location = MockData.weatherLocation;

    // Position on the gauge (0.0 to 1.0) based on temp range 15–45°C.
    final gaugePosition = ((temp - 15) / 30).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Label + location
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.sunMeterLabel,
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    location.toUpperCase(),
                    style: AppTypography.labelMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),

              // Temperature
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$temp°C',
                    style: AppTypography.temperature.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'feels',
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        '$feelsLike°',
                        style: AppTypography.titleSmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Gradient gauge bar
          SizedBox(
            height: 24,
            child: Stack(
              children: [
                // Bar background
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.sunMeterGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                // Position indicator
                Positioned(
                  left:
                      gaugePosition *
                      (MediaQuery.of(context).size.width -
                          112), // adjusted for padding
                  top: 2,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Gauge labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _GaugeLabel('Cool (20°)', Colors.white.withValues(alpha: 0.5)),
              _GaugeLabel('Warm (28°)', Colors.white.withValues(alpha: 0.5)),
              _GaugeLabel('Hot (35°)', Colors.white.withValues(alpha: 0.5)),
              _GaugeLabel('🔥 Extreme', Colors.white.withValues(alpha: 0.7)),
            ],
          ),

          const SizedBox(height: 12),

          // Tip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              AppStrings.sunMeterTip,
              style: AppTypography.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GaugeLabel extends StatelessWidget {
  const _GaugeLabel(this.text, this.color);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.labelSmall.copyWith(
        color: color,
        fontSize: 9,
        letterSpacing: 0.3,
      ),
    );
  }
}
