import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';

/// Main app shell with bottom navigation after authentication.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  DateTime? _lastBackPressTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.hhColors;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // If not on Home tab, go to Home tab
        if (widget.navigationShell.currentIndex != 0) {
          widget.navigationShell.goBranch(0);
          return;
        }

        // Double tap to exit logic
        final now = DateTime.now();
        if (_lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Press back again to exit',
                style: AppTypography.bodyMedium.copyWith(color: Colors.white),
              ),
              backgroundColor: colors.surfaceElevated,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }

        // Exit the app
        Navigator.of(context).pop();
      },
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: AppStrings.navHome,
                  isActive: widget.navigationShell.currentIndex == 0,
                  onTap: () => widget.navigationShell.goBranch(0),
                ),
                _NavItem(
                  icon: Icons.explore_outlined,
                  activeIcon: Icons.explore_rounded,
                  label: AppStrings.navExplore,
                  isActive: widget.navigationShell.currentIndex == 1,
                  onTap: () => widget.navigationShell.goBranch(1),
                ),
                _NavItem(
                  icon: Icons.calendar_today_outlined,
                  activeIcon: Icons.calendar_today_rounded,
                  label: AppStrings.navBookings,
                  isActive: widget.navigationShell.currentIndex == 2,
                  onTap: () => widget.navigationShell.goBranch(2),
                ),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: AppStrings.navSettings,
                  isActive: widget.navigationShell.currentIndex == 3,
                  onTap: () => widget.navigationShell.goBranch(3),
                ),
              ],
          ),
        ),
      ),
    ),
   ),
  );
 }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.85), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.1), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(_NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _bounceController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inactiveColor =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45);

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width * 0.04).clamp(10.0, 20.0),
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: widget.isActive
              ? AppColors.orangeBright.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _bounceAnimation.value,
                  child: child,
                );
              },
              child: Icon(
                widget.isActive ? widget.activeIcon : widget.icon,
                size: 24,
                color: widget.isActive ? AppColors.orangeBright : inactiveColor,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTypography.labelSmall.copyWith(
                color:
                    widget.isActive ? AppColors.orangeBright : inactiveColor,
                fontSize: 11,
                fontWeight:
                    widget.isActive ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.3,
              ),
              child: Text(widget.label),
            ),
          ],
        ),
      ),
    );
  }
}
