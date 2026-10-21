import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/features/profile_settings/presentation/providers/user_profile_provider.dart';
import 'package:fit_motiv/l10n/app_localizations.dart';
import 'package:fit_motiv/core/theme/theme_provider.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProfileProvider>();
    final profile = provider.profile;
    final isLoading = provider.isLoading;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.profile,
          style: AppTextStyles.heading3,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => provider.refreshProfile(),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : profile == null
          ? _buildErrorState(context, provider)
          : RefreshIndicator(
              color: Theme.of(context).colorScheme.primary,
              onRefresh: () => provider.refreshProfile(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  _buildProfileHeader(context, provider),
                  const SizedBox(height: 24),
                  _buildWeightProgress(context, profile),
                  const SizedBox(height: 24),
                  _buildInfoSection(
                    context,
                    profile.bio,
                    profile.activityLevel,
                    profile.fitnessGoal,
                  ),
                  const SizedBox(height: 24),
                  _buildSettingsSection(context),
                  const SizedBox(height: 24),
                  Text(
                    l10n.weight,
                    style: AppTextStyles.heading4,
                  ),
                  const SizedBox(height: 12),
                  _buildMetricsCard(
                    context,
                    profile.weight,
                    profile.height,
                    profile.age,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.profile,
                    style: AppTextStyles.heading4,
                  ),
                  const SizedBox(height: 12),
                  _buildAccountCard(
                    context,
                    profile.email,
                    profile.username,
                    profile.memberSince,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildErrorState(BuildContext context, UserProfileProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(l10n.couldNotLoadProfile, style: AppTextStyles.heading4),
            const SizedBox(height: 8),
            Text(
              provider.error ?? l10n.unknownError,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.refreshProfile(),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    UserProfileProvider provider,
  ) {
    final profile = provider.profile!;

    return Center(
      child: Column(
        children: [
          // Avatar con gradient o imagen
          GestureDetector(
            onTap: () => provider.pickAndUploadAvatar(),
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    image: profile.avatarUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(profile.avatarUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: profile.avatarUrl.isEmpty
                      ? Center(
                          child: Text(
                            profile.initials,
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(profile.displayName, style: AppTextStyles.heading2),
          if (profile.username.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '@${profile.username}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
          const SizedBox(height: 4),
          if (profile.memberSince.isNotEmpty)
            Text(
              profile.memberSince,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeightProgress(BuildContext context, dynamic profile) {
    final l10n = AppLocalizations.of(context)!;
    final diff = profile.weightDifference;
    final isLosing = diff < 0;

    return _card(
      context: context,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.weightProgress,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (isLosing ? Colors.green : Colors.orange)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${diff.toStringAsFixed(1)} lbs',
                      style: TextStyle(
                        color: isLosing ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearPercentIndicator(
                lineHeight: 12.0,
                percent: profile.weightProgressPercent.clamp(0.0, 1.0),
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                progressColor: Theme.of(context).colorScheme.primary,
                barRadius: const Radius.circular(6),
                animation: true,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.startWeightLabel(profile.initialWeight.toString()),
                    style: AppTextStyles.bodySmall,
                  ),
                  Text(
                    l10n.goalWeightLabel(profile.weight.toString()),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String bio,
    String activityLevel,
    String fitnessGoal,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (bio.isEmpty && activityLevel.isEmpty && fitnessGoal.isEmpty) {
      return const SizedBox.shrink();
    }

    return _card(
      context: context,
      children: [
        if (bio.isNotEmpty)
          _InfoRow(icon: Icons.person_outline, label: l10n.bio, value: bio),
        if (bio.isNotEmpty &&
            (activityLevel.isNotEmpty || fitnessGoal.isNotEmpty))
          const Divider(height: 1),
        if (activityLevel.isNotEmpty)
          _InfoRow(
            icon: Icons.speed,
            label: l10n.activityLevel,
            value: activityLevel,
          ),
        if (activityLevel.isNotEmpty && fitnessGoal.isNotEmpty)
          const Divider(height: 1),
        if (fitnessGoal.isNotEmpty)
          _InfoRow(
            icon: Icons.flag_outlined,
            label: l10n.fitnessGoal,
            value: fitnessGoal,
          ),
      ],
    );
  }

  Widget _buildMetricsCard(
    BuildContext context,
    double weight,
    double height,
    int age,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return _card(
      context: context,
      children: [
        if (weight > 0)
          _InfoRow(
            icon: Icons.monitor_weight_outlined,
            label: l10n.weight,
            value: l10n.weightWithUnit(weight.toStringAsFixed(1)),
          ),
        if (weight > 0 && height > 0) const Divider(height: 1),
        if (height > 0)
          _InfoRow(
            icon: Icons.height,
            label: l10n.height,
            value: l10n.heightWithUnit(height.toStringAsFixed(2)),
          ),
        if ((weight > 0 || height > 0) && age > 0) const Divider(height: 1),
        if (age > 0)
          _InfoRow(
            icon: Icons.cake_outlined,
            label: l10n.age,
            value: l10n.ageWithUnit(age.toString()),
          ),
      ],
    );
  }

  Widget _buildAccountCard(
    BuildContext context,
    String email,
    String username,
    String memberSince,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return _card(
      context: context,
      children: [
        _InfoRow(icon: Icons.email_outlined, label: l10n.email, value: email),
        if (username.isNotEmpty) ...[
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.alternate_email,
            label: l10n.username,
            value: username,
          ),
        ],
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.appSettings, style: AppTextStyles.heading4),
        const SizedBox(height: 12),
        _card(
          context: context,
          children: [
            ListTile(
              leading: Icon(
                Icons.language,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(l10n.language),
              subtitle: Text(
                localeProvider.locale.languageCode == 'en'
                    ? l10n.english
                    : l10n.spanish,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showLanguageDialog(context, localeProvider),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(
                Icons.palette_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(l10n.theme),
              subtitle: Text(themeProvider.themeMode.name.toUpperCase()),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showThemeDialog(context, themeProvider),
            ),
          ],
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context, LocaleProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.english),
              onTap: () {
                provider.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(l10n.spanish),
              onTap: () {
                provider.setLocale(const Locale('es'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, ThemeProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.chooseTheme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.system),
              leading: const Icon(Icons.brightness_auto),
              onTap: () {
                provider.setThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(l10n.light),
              leading: const Icon(Icons.light_mode),
              onTap: () {
                provider.setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(l10n.dark),
              leading: const Icon(Icons.dark_mode),
              onTap: () {
                provider.setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({
    required BuildContext context,
    required List<Widget> children,
  }) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Theme.of(context).cardTheme.color ?? Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          spreadRadius: 1,
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(children: children),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(label, style: AppTextStyles.bodySmall),
      subtitle: Text(
        value,
        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}
