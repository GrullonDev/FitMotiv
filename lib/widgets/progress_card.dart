import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
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
              Text('Weight Loss Progress', style: AppTextStyles.heading4),
              Text(
                '6/10 lbs',
                style: AppTextStyles.heading4.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 8.0,
            percent: 0.6,
            backgroundColor: AppColors.progressBackground,
            progressColor: AppColors.primary,
            barRadius: const Radius.circular(4),
            animation: true,
            animationDuration: 1000,
          ),
          const SizedBox(height: 12),
          Text(
            'Great job! You\'re 60% of the way to your goal.',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
