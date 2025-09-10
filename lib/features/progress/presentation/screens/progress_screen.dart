import 'package:flutter/material.dart';
import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text('Progress', style: AppTextStyles.heading3),
          centerTitle: true,
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Weekly'),
              Tab(text: 'Monthly'),
              Tab(text: 'Yearly'),
            ],
          ),
        ),
        body: TabBarView(
          children: const [
            _ProgressTab(period: 'Weekly'),
            _ProgressTab(period: 'Monthly'),
            _ProgressTab(period: 'Yearly'),
          ],
        ),
      ),
    );
  }
}

class _ProgressTab extends StatelessWidget {
  final String period;
  const _ProgressTab({required this.period});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChartCard(period: period),
          const SizedBox(height: 32),
          const _GoalsSection(),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String period;
  const _ChartCard({required this.period});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
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
              Text(
                'Weight Change',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Last $period',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '-2.5 lbs',
            style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            '-1.2%',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: Center(
              child: Text('Chart Placeholder', style: AppTextStyles.bodySmall),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalsSection extends StatelessWidget {
  const _GoalsSection();
  @override
  Widget build(BuildContext context) {
    final goals = [
      {
        'icon': Icons.fitness_center,
        'title': 'Weight Loss',
        'subtitle': 'Lose 5 lbs',
        'done': true,
      },
      {
        'icon': Icons.directions_run,
        'title': 'Activity',
        'subtitle': 'Run 3 times a week',
        'done': false,
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Goals', style: AppTextStyles.heading4),
            TextButton(
              onPressed: () {},
              child: Text(
                '+ Set New Goal',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...goals.map(
          (g) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(g['icon'] as IconData, color: AppColors.primary),
            title: Text(g['title'] as String, style: AppTextStyles.bodyMedium),
            subtitle: Text(
              g['subtitle'] as String,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            trailing: Icon(
              (g['done'] as bool)
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: (g['done'] as bool)
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
