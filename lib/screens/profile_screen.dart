import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text('Profile', style: AppTextStyles.heading3),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primary),
            onPressed: () {
              // TODO: Navigate to edit profile form
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150', // Placeholder avatar
                  ),
                ),
                const SizedBox(height: 12),
                Text('Sophia Carter', style: AppTextStyles.heading2),
                const SizedBox(height: 4),
                Text(
                  'Premium Member',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Joined 2 months ago',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Personal Goals', style: AppTextStyles.heading4),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildGoalRow('Starting Weight', '165 lbs', 'Current: 150 lbs'),
                _buildGoalRow('Goal Weight', '130 lbs', 'Current: 140 lbs'),
                _buildGoalRow('Weight Lost', '15 lbs', 'Current: 10 lbs'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Rewards', style: AppTextStyles.heading4),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildRewardItem('10% off on next purchase'),
                _buildRewardItem('Free workout session'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalRow(String title, String value, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(title, style: AppTextStyles.bodyMedium),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
      trailing: Text(
        value,
        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildRewardItem(String title) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(title, style: AppTextStyles.bodyMedium),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: () {},
    );
  }
}
