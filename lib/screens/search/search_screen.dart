import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/filter_sheet.dart';
import '../../widgets/search_input.dart';

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
                SearchInput(
                  controller: _searchController,
                  focusNode: _searchFocus,
                  onChanged: (value) => setState(() {}),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty && !_recentSearches.contains(value.trim())) {
                      setState(() {
                        _recentSearches.insert(0, value.trim());
                        if (_recentSearches.length > 8) {
                          _recentSearches.removeLast();
                        }
                      });
                    }
                  },
                  onFilterTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const FilterSheet(),
                    );
                  },
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
