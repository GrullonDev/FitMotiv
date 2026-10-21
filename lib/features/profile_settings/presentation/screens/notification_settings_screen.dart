import 'package:flutter/material.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/l10n/app_localizations.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _workoutReminders = true;
  bool _communityAlerts = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notifications)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSwitchTile(
            title: l10n.pushNotifications,
            subtitle: l10n.pushNotificationsSubtitle,
            value: _pushNotifications,
            onChanged: (v) => setState(() => _pushNotifications = v),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: l10n.workoutReminders,
            subtitle: l10n.workoutRemindersSubtitle,
            value: _workoutReminders,
            onChanged: (v) => setState(() => _workoutReminders = v),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: l10n.communityAlerts,
            subtitle: l10n.communityAlertsSubtitle,
            value: _communityAlerts,
            onChanged: (v) => setState(() => _communityAlerts = v),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle, style: AppTextStyles.bodyMedium),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
