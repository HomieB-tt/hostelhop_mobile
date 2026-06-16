import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../data/providers/data_providers.dart';
import '../../providers/theme_provider.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../widgets/gradient_button.dart';

/// Profile screen with avatar, info, and quick links.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.hhColors;
    final theme = Theme.of(context);
    final currentTheme = ref.watch(themeProvider);
    final isDark = currentTheme == ThemeMode.dark;
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.profile,
            style: AppTypography.titleLarge.copyWith(color: colors.textHigh),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // ── Guest Avatar ──
              Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.orangeBright.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_rounded,
                        size: 44,
                        color: Colors.white,
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scaleXY(
                    begin: 0.7,
                    end: 1,
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  ),

              const SizedBox(height: 16),

              Text(
                    'Guest User',
                    style: AppTypography.headlineSmall.copyWith(
                      color: colors.textHigh,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 350.ms, delay: 150.ms)
                  .slideY(begin: 0.06, end: 0),
              const SizedBox(height: 8),
              Text(
                'Login to edit or change profile',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(color: colors.textLow),
              ).animate().fadeIn(duration: 350.ms, delay: 250.ms),

              const SizedBox(height: 24),

              GradientButton(
                text: 'Login / Sign Up',
                onPressed: () => GoRouter.of(context).push('/login'),
              ).animate().fadeIn(duration: 350.ms, delay: 350.ms),

              const SizedBox(height: 32),

              // ── Dark mode toggle & About (always visible) ──
              Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: Column(
                      children: [
                        // Dark mode toggle
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, anim) =>
                                    RotationTransition(
                                      turns: Tween(
                                        begin: 0.75,
                                        end: 1.0,
                                      ).animate(anim),
                                      child: FadeTransition(
                                        opacity: anim,
                                        child: child,
                                      ),
                                    ),
                                child: Icon(
                                  isDark
                                      ? Icons.dark_mode_rounded
                                      : Icons.light_mode_rounded,
                                  key: ValueKey(isDark),
                                  size: 20,
                                  color: AppColors.orangeBright,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  AppStrings.darkMode,
                                  style: AppTypography.titleSmall.copyWith(
                                    color: colors.textHigh,
                                  ),
                                ),
                              ),
                              Switch(
                                value: isDark,
                                onChanged: (_) => ref
                                    .read(themeProvider.notifier)
                                    .toggleTheme(),
                                activeThumbColor: AppColors.orangeBright,
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1, color: theme.colorScheme.outline),
                        _ProfileTile(
                          icon: Icons.info_outline_rounded,
                          title: AppStrings.about,
                          subtitle: AppStrings.version,
                          colors: colors,
                          onTap: () {
                            showAboutDialog(
                              context: context,
                              applicationName: 'HostelHop',
                              applicationVersion: AppStrings.version,
                              applicationIcon: Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppColors.primaryGradient,
                                ),
                                child: const Center(
                                  child: Icon(Icons.location_on_rounded, color: Colors.white),
                                ),
                              ),
                              children: [
                                const SizedBox(height: 16),
                                Text('HostelHop is the easiest way to find and book student accommodation.', style: AppTypography.bodyMedium.copyWith(color: colors.textMid)),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 450.ms)
                  .slideY(begin: 0.06, end: 0),

              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    }

    final profileAsync = ref.watch(currentProfileProvider);

    return profileAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(AppStrings.profile, style: AppTypography.titleLarge.copyWith(color: colors.textHigh))),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => Scaffold(
        appBar: AppBar(title: Text(AppStrings.profile, style: AppTypography.titleLarge.copyWith(color: colors.textHigh))),
        body: const Center(child: Text('Failed to load profile')),
      ),
      data: (student) {
        final displayStudent = student;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppStrings.profile,
              style: AppTypography.titleLarge.copyWith(color: colors.textHigh),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.settings_outlined, color: colors.textMid),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // ── Avatar ──
                Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.orangeBright.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          displayStudent?.avatarInitials ??
                              (displayStudent?.fullName.isNotEmpty == true
                                  ? displayStudent!.fullName[0].toUpperCase()
                                  : '?'),
                          style: AppTypography.headlineMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .scaleXY(
                      begin: 0.7,
                      end: 1,
                      duration: 500.ms,
                      curve: Curves.easeOutBack,
                    ),

                const SizedBox(height: 16),

                Text(
                      displayStudent?.fullName ?? '',
                      style: AppTypography.headlineSmall.copyWith(
                        color: colors.textHigh,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 350.ms, delay: 150.ms)
                    .slideY(begin: 0.06, end: 0),
                const SizedBox(height: 4),
                Text(
                  displayStudent?.university ?? '',
                  style: AppTypography.bodyMedium.copyWith(color: colors.textMid),
                ).animate().fadeIn(duration: 350.ms, delay: 220.ms),
                const SizedBox(height: 4),
                Text(
                  displayStudent?.phone ?? '',
                  style: AppTypography.bodySmall.copyWith(color: colors.textLow),
                ).animate().fadeIn(duration: 350.ms, delay: 280.ms),

                const SizedBox(height: 28),

                // ── Info card ──
                Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.colorScheme.outline),
                      ),
                      child: Column(
                        children: [
                          _ProfileTile(
                            icon: Icons.person_outline_rounded,
                            title: AppStrings.editProfile,
                            colors: colors,
                            onTap: () {
                              GoRouter.of(context).go('/settings/edit-profile');
                            },
                          ),
                          Divider(height: 1, color: theme.colorScheme.outline),
                          _ProfileTile(
                            icon: Icons.calendar_today_outlined,
                            title: AppStrings.myBookings,
                            colors: colors,
                            onTap: () {
                              GoRouter.of(context).go('/bookings');
                            },
                          ),
                          Divider(height: 1, color: theme.colorScheme.outline),
                          _ProfileTile(
                            icon: Icons.receipt_long_outlined,
                            title: 'Payment History',
                            colors: colors,
                            onTap: () {
                              SnackBarUtils.show(context, 'Payment history feature coming soon');
                            },
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 350.ms)
                    .slideY(begin: 0.06, end: 0),

                const SizedBox(height: 16),

                // ── Settings ──
                Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.colorScheme.outline),
                      ),
                      child: Column(
                        children: [
                          // Dark mode toggle
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: Row(
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, anim) =>
                                      RotationTransition(
                                        turns: Tween(
                                          begin: 0.75,
                                          end: 1.0,
                                        ).animate(anim),
                                        child: FadeTransition(
                                          opacity: anim,
                                          child: child,
                                        ),
                                      ),
                                  child: Icon(
                                    isDark
                                        ? Icons.dark_mode_rounded
                                        : Icons.light_mode_rounded,
                                    key: ValueKey(isDark),
                                    size: 20,
                                    color: AppColors.orangeBright,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    AppStrings.darkMode,
                                    style: AppTypography.titleSmall.copyWith(
                                      color: colors.textHigh,
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: isDark,
                                  onChanged: (_) => ref
                                      .read(themeProvider.notifier)
                                      .toggleTheme(),
                                  activeThumbColor: AppColors.orangeBright,
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 1, color: theme.colorScheme.outline),
                          _ProfileTile(
                            icon: Icons.notifications_none_rounded,
                            title: AppStrings.pushNotifications,
                            colors: colors,
                            onTap: () {
                              SnackBarUtils.show(context, 'Push notifications settings coming soon');
                            },
                          ),
                          Divider(height: 1, color: theme.colorScheme.outline),
                          _ProfileTile(
                            icon: Icons.info_outline_rounded,
                            title: AppStrings.about,
                            subtitle: AppStrings.version,
                            colors: colors,
                            onTap: () {
                              showAboutDialog(
                                context: context,
                                applicationName: 'HostelHop',
                                applicationVersion: AppStrings.version,
                                applicationIcon: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: AppColors.primaryGradient,
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.location_on_rounded, color: Colors.white),
                                  ),
                                ),
                                children: [
                                  const SizedBox(height: 16),
                                  Text(
                                    'HostelHop is the easiest way to find and book student accommodation.',
                                    style: AppTypography.bodyMedium.copyWith(color: colors.textMid),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 450.ms)
                    .slideY(begin: 0.06, end: 0),

                const SizedBox(height: 16),

                // ── Sign Out ──
                Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.colorScheme.outline),
                      ),
                      child: _ProfileTile(
                        icon: Icons.logout_rounded,
                        title: AppStrings.signOut,
                        colors: colors,
                        isDestructive: true,
                        onTap: () {
                          ref.read(authProvider.notifier).signOut();
                          GoRouter.of(context).go('/login');
                        },
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 550.ms)
                    .slideY(begin: 0.06, end: 0),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.colors,
    required this.onTap,
    this.subtitle,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final HostelHopColors colors;
  final bool isDestructive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDestructive ? AppColors.error : AppColors.orangeBright,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleSmall.copyWith(
                      color: isDestructive ? AppColors.error : colors.textHigh,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textLow,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20, color: colors.textLow),
          ],
        ),
      ),
    );
  }
}
