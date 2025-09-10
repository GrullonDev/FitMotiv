import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(Icons.trending_up, color: color, size: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: AppTextStyles.heading2.copyWith(color: color)),
              const SizedBox(width: 4),
              Text(
                unit,
                style: AppTextStyles.bodyMedium.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: const [
        StatsCard(
          title: 'Steps Today',
          value: '8,432',
          unit: 'steps',
          icon: Icons.directions_walk,
          color: AppColors.primary,
        ),
        StatsCard(
          title: 'Calories Burned',
          value: '342',
          unit: 'kcal',
          icon: Icons.local_fire_department,
          color: Color(0xFFFF6B6B),
        ),
        StatsCard(
          title: 'Workout Time',
          value: '45',
          unit: 'min',
          icon: Icons.timer,
          color: Color(0xFF4ECDC4),
        ),
        StatsCard(
          title: 'Water Intake',
          value: '1.2',
          unit: 'L',
          icon: Icons.water_drop,
          color: Color(0xFF45B7D1),
        ),
      ],
    );
  }
}
