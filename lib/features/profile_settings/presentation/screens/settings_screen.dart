import 'package:animate_do/animate_do.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';
import 'package:fit_motiv/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _sendEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'prosystem155@gmail.com',
      query: 'subject=Soporte FitMotiv&body=Hola, necesito ayuda con...',
    );
    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      debugPrint('Could not launch $params');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text(localeProvider.translate('settings'), style: AppTextStyles.heading3)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          FadeInDown(duration: const Duration(milliseconds: 400), child: _buildSectionTitle('Profile')),
          FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: _buildSectionCard(context, [
              _buildSettingItem(
                context,
                icon: Icons.person_outline,
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: () => Navigator.pushNamed(context, '/profile'),
              ),
              _buildDivider(),
              _buildSettingItem(
                context,
                icon: Icons.fitness_center_outlined,
                title: 'Fitness Goals',
                subtitle: 'Set your workout and health goals',
                onTap: () {},
              ),
            ]),
          ),
          const SizedBox(height: 24),
          FadeInDown(duration: const Duration(milliseconds: 600), child: _buildSectionTitle('Preferences')),
          FadeInDown(
            duration: const Duration(milliseconds: 700),
            child: _buildSectionCard(context, [
              _buildSettingItem(
                context,
                icon: Icons.notifications_none,
                title: 'Notifications',
                subtitle: 'Manage your notification preferences',
                onTap: () => Navigator.pushNamed(context, '/notifications'),
              ),
              _buildDivider(),
              _buildSettingItem(
                context,
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                subtitle: 'Toggle dark mode on/off',
                trailing: Switch(
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (v) {
                    themeProvider.setThemeMode(v ? ThemeMode.dark : ThemeMode.light);
                  },
                  activeThumbColor: primaryColor,
                ),
              ),
              _buildDivider(),
              _buildSettingItem(
                context,
                icon: Icons.language_outlined,
                title: localeProvider.translate('language'),
                subtitle: localeProvider.locale.languageCode == 'en' ? 'English' : 'Español',
                onTap: () {
                  final newLocale = localeProvider.locale.languageCode == 'en'
                      ? const Locale('es')
                      : const Locale('en');
                  localeProvider.setLocale(newLocale);
                },
              ),
              _buildDivider(),
              _buildColorPicker(context, themeProvider),
            ]),
          ),
          const SizedBox(height: 24),
          FadeInDown(duration: const Duration(milliseconds: 800), child: _buildSectionTitle('Support')),
          FadeInDown(
            duration: const Duration(milliseconds: 900),
            child: _buildSectionCard(context, [
              _buildSettingItem(
                context,
                icon: Icons.help_outline,
                title: 'Help & FAQ',
                subtitle: 'Get help and find answers',
                onTap: () => Navigator.pushNamed(context, '/faq'),
              ),
              _buildDivider(),
              _buildSettingItem(
                context,
                icon: Icons.mail_outline,
                title: 'Send Feedback',
                subtitle: 'Communicate with support',
                onTap: _sendEmail,
              ),
            ]),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(title, style: AppTextStyles.heading4.copyWith(color: Colors.grey[600], letterSpacing: 0.5)),
    );
  }

  Widget _buildSectionCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: primaryColor, size: 24),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[500])),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 70, endIndent: 20, color: Colors.grey.withValues(alpha: 0.1));
  }

  Widget _buildColorPicker(BuildContext context, ThemeProvider themeProvider) {
    final colors = [
      const Color(0xFF00D4A3), // Green
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFF97316), // Orange
      const Color(0xFFEC4899), // Pink
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: themeProvider.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.palette_outlined, color: themeProvider.primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              const Text('App Color', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: colors.map((color) {
              final isSelected = themeProvider.primaryColor.value == color.value;
              return GestureDetector(
                onTap: () => themeProvider.setPrimaryColor(color),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: isSelected ? Colors.white : Colors.transparent, width: 3),
                    boxShadow: [
                      if (isSelected) BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8, spreadRadius: 2),
                    ],
                  ),
                  child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
