import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../data/mock/mock_data.dart';
import '../../providers/theme_provider.dart';

/// Profile screen with avatar, info, and quick links.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.hhColors;
    final theme = Theme.of(context);
    final student = MockData.studentProfile;
    final themeMode = ref.watch(themeProvider);

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
                  student.avatarInitials ?? 'BS',
                  style: AppTypography.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              student.fullName,
              style: AppTypography.headlineSmall.copyWith(
                color: colors.textHigh,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              student.university ?? '',
              style: AppTypography.bodyMedium.copyWith(color: colors.textMid),
            ),
            const SizedBox(height: 4),
            Text(
              student.phone,
              style: AppTypography.bodySmall.copyWith(color: colors.textLow),
            ),

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
                    onTap: () {},
                  ),
                  Divider(height: 1, color: theme.colorScheme.outline),
                  _ProfileTile(
                    icon: Icons.calendar_today_outlined,
                    title: AppStrings.myBookings,
                    colors: colors,
                    onTap: () {},
                  ),
                  Divider(height: 1, color: theme.colorScheme.outline),
                  _ProfileTile(
                    icon: Icons.receipt_long_outlined,
                    title: 'Payment History',
                    colors: colors,
                    onTap: () {},
                  ),
                ],
              ),
            ),

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
                        Icon(
                          themeMode == ThemeMode.dark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          size: 20,
                          color: AppColors.orangeBright,
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
                          value: themeMode == ThemeMode.dark,
                          onChanged: (_) =>
                              ref.read(themeProvider.notifier).toggleTheme(),
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
                    onTap: () {},
                  ),
                  Divider(height: 1, color: theme.colorScheme.outline),
                  _ProfileTile(
                    icon: Icons.info_outline_rounded,
                    title: AppStrings.about,
                    subtitle: AppStrings.version,
                    colors: colors,
                    onTap: () {},
                  ),
                ],
              ),
            ),

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
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
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
