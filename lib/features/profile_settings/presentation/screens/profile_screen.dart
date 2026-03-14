import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/features/profile_settings/presentation/providers/user_profile_provider.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';
import 'package:fit_motiv/core/theme/theme_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProfileProvider>();
    final profile = provider.profile;
    final isLoading = provider.isLoading;
    final l10n = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<LocaleProvider>().translate('profile'), style: AppTextStyles.heading3),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Theme.of(context).colorScheme.primary),
            onPressed: () => provider.refreshProfile(),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
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
                      _buildInfoSection(context, profile.bio, profile.activityLevel, profile.fitnessGoal),
                      const SizedBox(height: 24),
                      _buildSettingsSection(context),
                      const SizedBox(height: 24),
                      Text(l10n.translate('body_metrics'), style: AppTextStyles.heading4),
                      const SizedBox(height: 12),
                      _buildMetricsCard(context, profile.weight, profile.height, profile.age),
                      const SizedBox(height: 24),
                      Text(l10n.translate('account_info'), style: AppTextStyles.heading4),
                      const SizedBox(height: 12),
                      _buildAccountCard(context, profile.email, profile.username, profile.memberSince),
                    ],
                  ),
                ),
    );
  }

  Widget _buildErrorState(BuildContext context, UserProfileProvider provider) {
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
            Text(
              'Could not load profile',
              style: AppTextStyles.heading4,
            ),
            const SizedBox(height: 8),
            Text(
              provider.error ?? 'Unknown error',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.refreshProfile(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
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

  Widget _buildProfileHeader(BuildContext context, UserProfileProvider provider) {
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
                      colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withValues(alpha: 0.6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
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
                   Text('Weight Progress', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                     decoration: BoxDecoration(
                       color: (isLosing ? Colors.green : Colors.orange).withValues(alpha: 0.1),
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
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                progressColor: Theme.of(context).colorScheme.primary,
                barRadius: const Radius.circular(6),
                animation: true,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Start: ${profile.initialWeight} lbs', style: AppTextStyles.bodySmall),
                  Text('Goal: ${profile.weight} lbs', style: AppTextStyles.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context, String bio, String activityLevel, String fitnessGoal) {
    if (bio.isEmpty && activityLevel.isEmpty && fitnessGoal.isEmpty) {
      return const SizedBox.shrink();
    }

    return _card(
      context: context,
      children: [
        if (bio.isNotEmpty)
          _InfoRow(icon: Icons.person_outline, label: 'Bio', value: bio),
        if (bio.isNotEmpty && (activityLevel.isNotEmpty || fitnessGoal.isNotEmpty))
          const Divider(height: 1),
        if (activityLevel.isNotEmpty)
          _InfoRow(icon: Icons.speed, label: 'Activity Level', value: activityLevel),
        if (activityLevel.isNotEmpty && fitnessGoal.isNotEmpty)
          const Divider(height: 1),
        if (fitnessGoal.isNotEmpty)
          _InfoRow(icon: Icons.flag_outlined, label: 'Fitness Goal', value: fitnessGoal),
      ],
    );
  }

  Widget _buildMetricsCard(BuildContext context, double weight, double height, int age) {
    return _card(
      context: context,
      children: [
        if (weight > 0)
          _InfoRow(
            icon: Icons.monitor_weight_outlined,
            label: 'Weight',
            value: '${weight.toStringAsFixed(1)} lbs',
          ),
        if (weight > 0 && height > 0) const Divider(height: 1),
        if (height > 0)
          _InfoRow(
            icon: Icons.height,
            label: 'Height',
            value: '${height.toStringAsFixed(2)} m',
          ),
        if ((weight > 0 || height > 0) && age > 0) const Divider(height: 1),
        if (age > 0)
          _InfoRow(
            icon: Icons.cake_outlined,
            label: 'Age',
            value: '$age years',
          ),
      ],
    );
  }

  Widget _buildAccountCard(BuildContext context, String email, String username, String memberSince) {
    return _card(
      context: context,
      children: [
        _InfoRow(icon: Icons.email_outlined, label: 'Email', value: email),
        if (username.isNotEmpty) ...[
          const Divider(height: 1),
          _InfoRow(icon: Icons.alternate_email, label: 'Username', value: username),
        ],
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('App Settings', style: AppTextStyles.heading4),
        const SizedBox(height: 12),
        _card(
          context: context,
          children: [
            ListTile(
              leading: Icon(Icons.language, color: Theme.of(context).colorScheme.primary),
              title: Text(localeProvider.translate('language')),
              subtitle: Text(localeProvider.locale.languageCode == 'en' ? 'English' : 'Español'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showLanguageDialog(context, localeProvider),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.palette_outlined, color: Theme.of(context).colorScheme.primary),
              title: const Text('Theme'),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(provider.translate('language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                provider.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Español'),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('System'),
              leading: const Icon(Icons.brightness_auto),
              onTap: () {
                provider.setThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Light'),
              leading: const Icon(Icons.light_mode),
              onTap: () {
                provider.setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Dark'),
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

  Widget _card({required BuildContext context, required List<Widget> children}) => Container(
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
        child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
      ),
      title: Text(
        label,
        style: AppTextStyles.bodySmall,
      ),
      subtitle: Text(
        value,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
