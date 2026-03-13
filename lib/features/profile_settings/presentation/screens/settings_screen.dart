import 'package:flutter/material.dart';
import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/features/profile_settings/presentation/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.heading3),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection(
            title: 'Profile',
            items: [
              _buildSettingItem(
                icon: Icons.person,
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                ),
              ),
              _buildSettingItem(
                icon: Icons.fitness_center,
                title: 'Fitness Goals',
                subtitle: 'Set your workout and health goals',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Preferences',
            items: [
              _buildSettingItem(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Manage your notification preferences',
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                subtitle: 'Toggle dark mode on/off',
                onTap: () {},
                trailing: Switch(
                  value: false,
                  onChanged: (v) {},
                  activeThumbColor: AppColors.primary,
                ),
              ),
              _buildSettingItem(
                icon: Icons.language,
                title: context.watch<LocaleProvider>().translate('language'),
                subtitle: context.watch<LocaleProvider>().locale.languageCode == 'en' ? 'English' : 'Español',
                onTap: () {
                  final provider = context.read<LocaleProvider>();
                  if (provider.locale.languageCode == 'en') {
                    provider.setLocale(const Locale('es'));
                  } else {
                    provider.setLocale(const Locale('en'));
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Support',
            items: [
              _buildSettingItem(
                icon: Icons.help,
                title: 'Help & FAQ',
                subtitle: 'Get help and find answers',
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.feedback,
                title: 'Send Feedback',
                subtitle: 'Share your thoughts with us',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.heading4),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(children: items),
          ),
        ],
      );

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) => ListTile(
    leading: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: AppColors.primary, size: 20),
    ),
    title: Text(
      title,
      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
    ),
    subtitle: Text(subtitle, style: AppTextStyles.bodyMedium),
    trailing: trailing ?? const Icon(Icons.chevron_right),
    onTap: onTap,
  );
}
