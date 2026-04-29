import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/gradient_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:go_router/go_router.dart';

/// Onboarding screen with 2 slides introducing HostelHop to new students.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
      icon: Icons.apartment_rounded,
      title: AppStrings.onboardingTitle1,
      subtitle: AppStrings.onboardingSubtitle1,
      accentColor: AppColors.orangeBright,
    ),
    _OnboardingPage(
      icon: Icons.lock_rounded,
      title: AppStrings.onboardingTitle2,
      subtitle: AppStrings.onboardingSubtitle2,
      accentColor: AppColors.orangePrimary,
    ),
  ];

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  void _handleNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    context.go('/login');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Skip button ──
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: TextButton(
                  onPressed: _navigateToLogin,
                  child: Text(
                    AppStrings.skip,
                    style: AppTypography.labelLarge.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 300.ms),

            // ── Page content ──
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration — large icon in a gradient circle.
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                page.accentColor.withValues(alpha: 0.15),
                                page.accentColor.withValues(alpha: 0.05),
                              ],
                            ),
                            border: Border.all(
                              color: page.accentColor.withValues(alpha: 0.2),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            page.icon,
                            size: 80,
                            color: page.accentColor,
                          ),
                        )
                            .animate(
                              key: ValueKey('icon_$index'),
                            )
                            .fadeIn(duration: 400.ms)
                            .scaleXY(
                              begin: 0.8,
                              end: 1,
                              duration: 500.ms,
                              curve: Curves.easeOutBack,
                            ),

                        const SizedBox(height: 48),

                        Text(
                          page.title,
                          style: AppTypography.headlineLarge.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        )
                            .animate(key: ValueKey('title_$index'))
                            .fadeIn(duration: 400.ms, delay: 150.ms)
                            .slideY(begin: 0.08, end: 0),

                        const SizedBox(height: 16),

                        Text(
                          page.subtitle,
                          style: AppTypography.bodyLarge.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.center,
                        )
                            .animate(key: ValueKey('sub_$index'))
                            .fadeIn(duration: 400.ms, delay: 280.ms)
                            .slideY(begin: 0.06, end: 0),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ── Bottom section: dots + button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.orangeBright,
                      dotColor:
                          AppColors.orangeBright.withValues(alpha: 0.2),
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                      spacing: 6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: GradientButton(
                      key: ValueKey(isLastPage),
                      onPressed: _handleNext,
                      text: isLastPage
                          ? AppStrings.getStarted
                          : AppStrings.next,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 500.ms)
                .slideY(begin: 0.1, end: 0),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
}
