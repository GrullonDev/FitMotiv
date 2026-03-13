import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:fit_motiv/features/profile_settings/presentation/providers/user_profile_provider.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<UserProfileProvider>();
    final profile = profileProvider.profile;

    if (profile == null) return const SizedBox.shrink();

    final diff = profile.weightDifference;
    final progress = profile.weightProgressPercent;
    final isLosing = diff < 0;
    final absDiff = diff.abs();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Weight Progress', style: AppTextStyles.heading4),
              Text(
                '${absDiff.toStringAsFixed(1)} lbs ${isLosing ? 'lost' : 'gained'}',
                style: AppTextStyles.heading4.copyWith(
                  color: isLosing ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 8.0,
            percent: progress.clamp(0.0, 1.0),
            backgroundColor: AppColors.progressBackground,
            progressColor: AppColors.primary,
            barRadius: const Radius.circular(4),
            animation: true,
            animationDuration: 1000,
          ),
          const SizedBox(height: 12),
          Text(
            isLosing 
              ? 'Great job! You\'ve lost ${absDiff.toStringAsFixed(1)} lbs since you started.'
              : 'Keep pushing! You\'ve gained ${absDiff.toStringAsFixed(1)} lbs since you started.',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
