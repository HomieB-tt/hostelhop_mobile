import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/weather_provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_typography.dart';
import '../core/constants/app_strings.dart';
import '../data/mock/mock_data.dart';

/// Sun Meter — compact weather gauge card for the home screen.
///
/// Renders as a standalone card on the page background (not inside the
/// orange header gradient). Shows temperature, feels-like, a colored
/// gradient bar with position indicator, and a Luganda tip.
class SunMeter extends ConsumerWidget {
  const SunMeter({
    super.key,
    this.temperature,
    this.feelsLike,
    this.location,
  });

  /// Temperature in °C. Falls back to provider or mock data if null.
  final int? temperature;

  /// Feels-like temperature in °C.
  final int? feelsLike;

  /// Location name (e.g. "Kampala").
  final String? location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);

    return weatherAsync.when(
      data: (weather) {
        final temp = temperature ??
            (weather?.temperature.toInt() ?? MockData.weatherTemp);
        final feels = feelsLike ??
            (weather?.feelsLike.toInt() ?? MockData.weatherFeelsLike);
        final loc =
            location ?? (weather?.location ?? MockData.weatherLocation);

        return _buildMeter(context, temp, feels, loc);
      },
      loading: () => _buildLoadingState(context),
      error: (err, stack) => _buildMeter(
        context,
        temperature ?? MockData.weatherTemp,
        feelsLike ?? MockData.weatherFeelsLike,
        location ?? MockData.weatherLocation,
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final colors = context.hhColors;
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.orangeBright,
          ),
        ),
      ),
    );
  }

  Widget _buildMeter(BuildContext context, int temp, int feels, String loc) {
    final colors = context.hhColors;
    final theme = Theme.of(context);

    // Position on the gauge (0.0 to 1.0) based on temp range 15–45°C.
    final gaugePosition = ((temp - 15) / 30).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label + location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.wb_sunny_rounded,
                          color: AppColors.orangeBright,
                          size: 13,
                        )
                            .animate(
                                onPlay: (controller) => controller.repeat())
                            .scaleXY(
                              begin: 1.0,
                              end: 1.2,
                              duration: 1500.ms,
                              curve: Curves.easeInOut,
                            )
                            .then()
                            .scaleXY(
                              begin: 1.2,
                              end: 1.0,
                              duration: 1500.ms,
                              curve: Curves.easeInOut,
                            ),
                        const SizedBox(width: 5),
                        Text(
                          AppStrings.sunMeterLabel,
                          style: AppTypography.labelSmall.copyWith(
                            color: colors.textMid,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w800,
                            fontSize: 9,
                          ),
                        ),
                        Text(
                          ' · ',
                          style: AppTypography.labelSmall.copyWith(
                            color: colors.textLow,
                            fontSize: 9,
                          ),
                        ),
                        Text(
                          loc.toUpperCase(),
                          style: AppTypography.labelSmall.copyWith(
                            color: colors.textHigh,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w700,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Temperature Display
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$temp°C',
                    style: AppTypography.temperature.copyWith(
                      color: colors.textHigh,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'feels',
                          style: AppTypography.labelSmall.copyWith(
                            color: colors.textLow,
                            fontSize: 9,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          '$feels°',
                          style: AppTypography.labelSmall.copyWith(
                            color: colors.textMid,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Gradient Gauge
          SizedBox(
            height: 20,
            child: Stack(
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: AppColors.sunMeterGradient,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final indicatorLeft =
                        gaugePosition * (constraints.maxWidth - 20);
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: indicatorLeft),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOutBack,
                          builder: (context, value, child) {
                            return Positioned(
                              left: value,
                              top: 0,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                      color: AppColors.orangeBright, width: 2.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.orangePrimary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Gauge labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _GaugeLabel('Cool (20°)', colors.textLow),
              _GaugeLabel('Warm (28°)', colors.textLow),
              _GaugeLabel('Hot (35°)', colors.textLow),
              _GaugeLabel('🔥 Extreme', colors.textMid),
            ],
          ),

          const SizedBox(height: 10),

          // Dynamic Tip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.warningSoft,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  temp > 30
                      ? Icons.warning_amber_rounded
                      : Icons.info_outline_rounded,
                  color: AppColors.warning,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppStrings.sunMeterTip,
                    style: AppTypography.bodySmall.copyWith(
                      color: colors.textMid,
                      fontSize: 10,
                      height: 1.4,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
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
        fontSize: 8,
        letterSpacing: 0.2,
      ),
    );
  }
}
