import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/features/profile_settings/presentation/providers/user_profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProfileProvider>();
    final profile = provider.profile;
    final isLoading = provider.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text('My Profile', style: AppTextStyles.heading3),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: () => provider.refreshProfile(),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : profile == null
              ? _buildErrorState(context, provider)
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => provider.refreshProfile(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildProfileHeader(context, provider),
                      const SizedBox(height: 24),
                      _buildInfoSection(profile.bio, profile.activityLevel, profile.fitnessGoal),
                      const SizedBox(height: 24),
                      Text('Body Metrics', style: AppTextStyles.heading4),
                      const SizedBox(height: 12),
                      _buildMetricsCard(profile.weight, profile.height, profile.age),
                      const SizedBox(height: 24),
                      Text('Account Info', style: AppTextStyles.heading4),
                      const SizedBox(height: 12),
                      _buildAccountCard(profile.email, profile.username, profile.memberSince),
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
                backgroundColor: AppColors.primary,
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
          // Avatar con gradient
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                profile.initials,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(profile.displayName, style: AppTextStyles.heading2),
          if (profile.username.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '@${profile.username}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
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

  Widget _buildInfoSection(String bio, String activityLevel, String fitnessGoal) {
    if (bio.isEmpty && activityLevel.isEmpty && fitnessGoal.isEmpty) {
      return const SizedBox.shrink();
    }

    return _card(
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

  Widget _buildMetricsCard(double weight, double height, int age) {
    return _card(
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

  Widget _buildAccountCard(String email, String username, String memberSince) {
    return _card(
      children: [
        _InfoRow(icon: Icons.email_outlined, label: 'Email', value: email),
        if (username.isNotEmpty) ...[
          const Divider(height: 1),
          _InfoRow(icon: Icons.alternate_email, label: 'Username', value: username),
        ],
      ],
    );
  }

  Widget _card({required List<Widget> children}) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.08),
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
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      subtitle: Text(
        value,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
