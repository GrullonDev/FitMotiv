import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/features/progress/presentation/providers/progress_provider.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgressProvider>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.watch<LocaleProvider>().translate('progress'), style: AppTextStyles.heading3),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.primary),
              onPressed: () => provider.refreshAll(),
            ),
          ],
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Weight'),
              Tab(text: 'Goals'),
            ],
          ),
        ),
        body: provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : TabBarView(
                children: [
                  _OverviewTab(provider: provider),
                  _WeightTab(provider: provider),
                  _GoalsTab(provider: provider),
                ],
              ),
      ),
    );
  }
}

/// Tab de resumen general
class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.provider});
  final ProgressProvider provider;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => provider.refreshAll(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats cards row
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    icon: Icons.fitness_center,
                    label: 'Workouts',
                    value: '${provider.totalSessions}',
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatBox(
                    icon: Icons.local_fire_department,
                    label: 'Calories',
                    value: '${provider.totalCalories}',
                    color: const Color(0xFFFF6B6B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    icon: Icons.monitor_weight,
                    label: 'Current',
                    value: provider.latestWeight != null
                        ? '${provider.latestWeight!.toStringAsFixed(1)} lbs'
                        : '-- lbs',
                    color: const Color(0xFF4ECDC4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatBox(
                    icon: Icons.trending_down,
                    label: 'Change',
                    value: provider.weightChange != null
                        ? '${provider.weightChange! >= 0 ? "+" : ""}${provider.weightChange!.toStringAsFixed(1)} lbs'
                        : '-- lbs',
                    color: provider.weightChange != null && provider.weightChange! < 0
                        ? AppColors.success
                        : const Color(0xFFFF6B6B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent workout sessions
            Text('Recent Sessions', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            if (provider.sessions.isEmpty)
              _buildEmptyCard(
                context,
                'No sessions yet',
                'Complete a workout to see your history.',
                Icons.history,
              )
            else
              ...provider.sessions.take(5).map((session) => _SessionCard(session: session)),

            const SizedBox(height: 24),

            // Weight log
            Text('Weight History', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            if (provider.weightLog.isEmpty)
              _buildEmptyCard(
                context,
                'No weight entries',
                'Start tracking your weight to see progress.',
                Icons.monitor_weight_outlined,
              )
            else
              ...provider.weightLog.take(5).map((entry) => _WeightEntry(entry: entry)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context, String title, String subtitle, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: AppColors.textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

/// Tab de peso
class _WeightTab extends StatelessWidget {
  const _WeightTab({required this.provider});
  final ProgressProvider provider;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => provider.refreshAll(),
      child: provider.weightLog.isEmpty
          ? SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),
                      Icon(
                        Icons.monitor_weight_outlined,
                        size: 64,
                        color: AppColors.textSecondary.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 16),
                      Text('No weight records', style: AppTextStyles.heading4),
                      const SizedBox(height: 8),
                      Text(
                        'Start logging your weight to track progress over time.',
                        style: AppTextStyles.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: provider.weightLog.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return _WeightEntry(entry: provider.weightLog[index]);
              },
            ),
    );
  }
}

/// Tab de metas
class _GoalsTab extends StatelessWidget {
  const _GoalsTab({required this.provider});
  final ProgressProvider provider;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => provider.refreshAll(),
      child: provider.goals.isEmpty
          ? SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),
                      Icon(
                        Icons.flag_outlined,
                        size: 64,
                        color: AppColors.textSecondary.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 16),
                      Text('No goals set', style: AppTextStyles.heading4),
                      const SizedBox(height: 8),
                      Text(
                        'Set goals to track your fitness journey.',
                        style: AppTextStyles.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: provider.goals.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final goal = provider.goals[index];
                final isCompleted = goal['is_completed'] as bool? ?? false;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color ?? Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (isCompleted ? AppColors.success : AppColors.primary)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isCompleted ? Icons.check_circle : Icons.flag_outlined,
                          color: isCompleted ? AppColors.success : AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goal['title'] as String? ?? '',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                decoration: isCompleted ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            if ((goal['description'] as String? ?? '').isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                goal['description'] as String,
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => provider.toggleGoal(
                          goal['id'] as String,
                          !isCompleted,
                        ),
                        child: Icon(
                          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: isCompleted ? AppColors.success : AppColors.textSecondary,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// ─────────────────────────────────────────
// Helper Widgets
// ─────────────────────────────────────────

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.heading3.copyWith(color: color),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session});
  final Map<String, dynamic> session;

  @override
  Widget build(BuildContext context) {
    final name = session['workout_name'] as String? ?? 'Workout';
    final duration = session['duration_minutes'] as int? ?? 0;
    final calories = session['calories_burned'] as int? ?? 0;
    final completedAt = session['completed_at'] as String? ?? '';

    String timeAgo = '';
    if (completedAt.isNotEmpty) {
      try {
        final date = DateTime.parse(completedAt);
        final diff = DateTime.now().difference(date);
        if (diff.inDays > 0) {
          timeAgo = '${diff.inDays}d ago';
        } else if (diff.inHours > 0) {
          timeAgo = '${diff.inHours}h ago';
        } else {
          timeAgo = '${diff.inMinutes}m ago';
        }
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.fitness_center, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                )),
                const SizedBox(height: 2),
                Text(
                  '${duration}min • ${calories}cal ${timeAgo.isNotEmpty ? "• $timeAgo" : ""}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightEntry extends StatelessWidget {
  const _WeightEntry({required this.entry});
  final Map<String, dynamic> entry;

  @override
  Widget build(BuildContext context) {
    final weight = (entry['weight'] as num?)?.toDouble() ?? 0;
    final recordedAt = entry['recorded_at'] as String? ?? '';
    final notes = entry['notes'] as String? ?? '';

    String dateStr = '';
    if (recordedAt.isNotEmpty) {
      try {
        final date = DateTime.parse(recordedAt);
        dateStr = '${date.month}/${date.day}/${date.year}';
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF4ECDC4).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.monitor_weight, color: Color(0xFF4ECDC4), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weight.toStringAsFixed(1)} lbs',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (notes.isNotEmpty)
                  Text(notes, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          if (dateStr.isNotEmpty)
            Text(dateStr, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
