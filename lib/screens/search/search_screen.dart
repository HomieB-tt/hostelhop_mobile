import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/filter_sheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  
  // Mock recent searches
  final List<String> _recentSearches = [
    'Baskon Hostel',
    'Kikoni Area',
    'Premium single rooms',
    'Hostels with Wi-Fi',
  ];

  @override
  void initState() {
    super.initState();
    // Auto-focus search field when arriving on this tab
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.hhColors;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Glassmorphism Search Bar
          Container(
            padding: EdgeInsets.only(
              top: topPadding + 16,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              gradient: AppColors.splashGradient,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search',
                  style: AppTypography.displaySmall.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Glassmorphism Search Input
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Icon(
                            Icons.search_rounded,
                            color: Colors.white.withValues(alpha: 0.7),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocus,
                              style: AppTypography.bodyMedium.copyWith(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: AppStrings.searchHint,
                                hintStyle: AppTypography.bodyMedium.copyWith(
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: const EdgeInsets.only(bottom: 12),
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                              onSubmitted: (value) {
                                // Add to recents if not empty
                                if (value.trim().isNotEmpty && !_recentSearches.contains(value.trim())) {
                                  setState(() {
                                    _recentSearches.insert(0, value.trim());
                                    if (_recentSearches.length > 8) {
                                      _recentSearches.removeLast();
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.transparent,
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white.withValues(alpha: 0.7),
                                  size: 18,
                                ),
                              ),
                            ),
                          const SizedBox(width: 4),
                          // Filter button
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => const FilterSheet(),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.tune_rounded,
                                color: Colors.white.withValues(alpha: 0.8),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().slideY(begin: -0.1, duration: 400.ms, curve: Curves.easeOutCubic),

          // Content Area
          Expanded(
            child: _searchController.text.isEmpty
                ? _buildRecentSearches(colors)
                : _buildSearchResults(colors),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches(HostelHopColors colors) {
    if (_recentSearches.isEmpty) {
      return Center(
        child: Text(
          'Search for hostels or areas',
          style: AppTypography.bodyMedium.copyWith(color: colors.textLow),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Searches',
              style: AppTypography.titleMedium.copyWith(
                color: colors.textHigh,
              ),
            ),
            if (_recentSearches.isNotEmpty)
              TextButton(
                onPressed: () {
                  setState(() {
                    _recentSearches.clear();
                  });
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.orangeBright,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Clear',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.orangeBright,
                  ),
                ),
              ),
          ],
        ).animate().fadeIn(delay: 100.ms),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: List.generate(_recentSearches.length, (index) {
            final query = _recentSearches[index];
            return GestureDetector(
              onTap: () {
                _searchController.text = query;
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 14,
                      color: colors.textLow,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      query,
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textMid,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: Duration(milliseconds: 150 + (index * 50)));
          }),
        ),
      ],
    );
  }

  Widget _buildSearchResults(HostelHopColors colors) {
    // We can either fetch the Provider here or just show a message telling the user to use the main list.
    // For now, since the home screen handles filtering, we'll suggest going back to home,
    // OR we could actually render the list here. Let's just show a placeholder as we'll implement full search later.
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            size: 64,
            color: colors.textLow.withValues(alpha: 0.3),
          ).animate().scale(delay: 200.ms),
          const SizedBox(height: 16),
          Text(
            'Searching for "${_searchController.text}"...',
            style: AppTypography.titleMedium.copyWith(color: colors.textMid),
          ),
          const SizedBox(height: 8),
          Text(
            'Results will appear here in the final version.',
            style: AppTypography.bodySmall.copyWith(color: colors.textLow),
          ),
        ],
      ).animate().fadeIn(),
    );
  }
}
