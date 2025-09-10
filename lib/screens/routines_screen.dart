import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/sample_data.dart';

class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final all = SampleData.workouts;
    final cardio = all.where((w) => w.category == 'Cardio').toList();
    final strength = all.where((w) => w.category == 'Strength').toList();
    final flexibility = all.where((w) => w.category == 'Flexibility').toList();
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          title: Text('Routines', style: AppTextStyles.heading3),
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Cardio'),
              Tab(text: 'Strength'),
              Tab(text: 'Flexibility'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildGrid(all),
            _buildGrid(cardio),
            _buildGrid(strength),
            _buildGrid(flexibility),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List workouts) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: workouts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final w = workouts[index];
          return _RoutineCard(w.name, w.duration, w.category);
        },
      ),
    );
  }
}

class _RoutineCard extends StatelessWidget {
  final String title;
  final int duration;
  final String category;
  const _RoutineCard(this.title, this.duration, this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 100,
              color: AppColors.primary.withValues(alpha: 0.1),
              child: Center(
                child: Icon(
                  Icons.directions_run,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  '$duration min • $category',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
