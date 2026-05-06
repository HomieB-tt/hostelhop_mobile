import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/weather_provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/constants/app_strings.dart';
import '../data/mock/mock_data.dart';

/// Sun Meter — weather gauge widget for the home screen header.
///
/// Shows temperature, feels-like, gradient bar with position indicator,
/// and a Luganda tip.
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
        final temp = temperature ?? (weather?.temperature.toInt() ?? MockData.weatherTemp);
        final feels = feelsLike ?? (weather?.feelsLike.toInt() ?? MockData.weatherFeelsLike);
        final loc = location ?? (weather?.location ?? MockData.weatherLocation);

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
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildMeter(BuildContext context, int temp, int feels, String loc) {
    // Position on the gauge (0.0 to 1.0) based on temp range 15–45°C.
    final gaugePosition = ((temp - 15) / 30).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with Pulsing Sun
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          color: Colors.white,
                          size: 14,
                        )
                            .animate(onPlay: (controller) => controller.repeat())
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
                        const SizedBox(width: 6),
                        Text(
                          AppStrings.sunMeterLabel,
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      loc.toUpperCase(),
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.white,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Temperature Display
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$temp°C',
                    style: AppTypography.temperature.copyWith(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'FEELS LIKE $feels°',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Enhanced Gradient Gauge
          SizedBox(
            height: 24,
            child: Stack(
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    gradient: AppColors.sunMeterGradient,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final indicatorLeft =
                        gaugePosition * (constraints.maxWidth - 24);
                    return Positioned(
                      left: indicatorLeft,
                      top: 0,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: indicatorLeft),
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(value - indicatorLeft, 0),
                            child: child,
                          );
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.white, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.orangePrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Gauge labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _GaugeLabel('Cool', Colors.white.withValues(alpha: 0.6)),
              _GaugeLabel('Warm', Colors.white.withValues(alpha: 0.6)),
              _GaugeLabel('Hot', Colors.white.withValues(alpha: 0.6)),
              _GaugeLabel('Extreme', Colors.white.withValues(alpha: 0.9)),
            ],
          ),

          const SizedBox(height: 14),

          // Dynamic Tip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  temp > 30 ? Icons.warning_amber_rounded : Icons.info_outline_rounded,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 16,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppStrings.sunMeterTip,
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 11,
                      height: 1.4,
                      fontStyle: FontStyle.italic,
                    ),
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
        fontSize: 9,
        letterSpacing: 0.3,
      ),
    );
  }
}
