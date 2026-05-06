import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';


class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  // Price range 500K - 1.8M
  RangeValues _priceRange = const RangeValues(500000, 1800000);
  
  // Room types
  String? _selectedRoomType;
  final List<String> _roomTypes = ['Single', 'Double', 'Triple'];

  // Amenities
  final Set<String> _selectedAmenities = {};
  final List<String> _availableAmenities = [
    'Wi-Fi',
    'Shuttle',
    'Security',
    'Pool',
    'Gym',
    'Restaurant',
    'Laundry',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.hhColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: AppTypography.titleLarge.copyWith(color: colors.textHigh),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _priceRange = const RangeValues(500000, 1800000);
                      _selectedRoomType = null;
                      _selectedAmenities.clear();
                    });
                  },
                  child: Text(
                    'Reset',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.orangeBright,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),

          // Price Range
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price Range (Per Semester)',
                  style: AppTypography.titleMedium.copyWith(color: colors.textHigh),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'UGX ${_formatPrice(_priceRange.start)}',
                      style: AppTypography.bodySmall.copyWith(color: colors.textMid),
                    ),
                    Text(
                      'UGX ${_formatPrice(_priceRange.end)}',
                      style: AppTypography.bodySmall.copyWith(color: colors.textMid),
                    ),
                  ],
                ),
                RangeSlider(
                  values: _priceRange,
                  min: 500000,
                  max: 1800000,
                  divisions: 13, // 100k increments
                  activeColor: AppColors.orangeBright,
                  inactiveColor: colors.border,
                  onChanged: (values) {
                    setState(() {
                      _priceRange = values;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Room Type
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Room Type',
                  style: AppTypography.titleMedium.copyWith(color: colors.textHigh),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _roomTypes.map((type) {
                    final isSelected = _selectedRoomType == type;
                    return ChoiceChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedRoomType = selected ? type : null;
                        });
                      },
                      selectedColor: AppColors.orangeBright.withValues(alpha: 0.2),
                      backgroundColor: colors.surfaceElevated,
                      labelStyle: AppTypography.bodyMedium.copyWith(
                        color: isSelected ? AppColors.orangeBright : colors.textMid,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppColors.orangeBright : colors.border,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Amenities
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amenities',
                  style: AppTypography.titleMedium.copyWith(color: colors.textHigh),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _availableAmenities.map((amenity) {
                    final isSelected = _selectedAmenities.contains(amenity);
                    return FilterChip(
                      label: Text(amenity),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedAmenities.add(amenity);
                          } else {
                            _selectedAmenities.remove(amenity);
                          }
                        });
                      },
                      selectedColor: AppColors.orangeBright.withValues(alpha: 0.2),
                      backgroundColor: colors.surfaceElevated,
                      checkmarkColor: AppColors.orangeBright,
                      labelStyle: AppTypography.bodyMedium.copyWith(
                        color: isSelected ? AppColors.orangeBright : colors.textMid,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppColors.orangeBright : colors.border,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Apply Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context, {
                  'minPrice': _priceRange.start,
                  'maxPrice': _priceRange.end,
                  'roomType': _selectedRoomType,
                  'amenities': _selectedAmenities.toList(),
                });
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.orangeBright,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Show Results',
                style: AppTypography.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    return '${(value / 1000).toStringAsFixed(0)}K';
  }
}
