import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';
import 'package:fit_motiv/features/routines/presentation/providers/workout_provider.dart';
import 'package:fit_motiv/features/routines/presentation/screens/routine_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(context.watch<LocaleProvider>().translate('routines'), style: AppTextStyles.heading3),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
              onPressed: () {
                // TODO: Implement search
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(text: context.read<LocaleProvider>().translate('all')),
              Tab(text: context.read<LocaleProvider>().translate('cardio')),
              Tab(text: context.read<LocaleProvider>().translate('strength')),
              Tab(text: context.read<LocaleProvider>().translate('flexibility')),
            ],
          ),
        ),
        body: provider.isLoading
            ? Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary))
            : provider.workouts.isEmpty
            ? _buildEmptyState(context, provider)
            : TabBarView(
                children: [
                  _buildGrid(context, provider.getByCategory('All'), provider),
                  _buildGrid(context, provider.getByCategory('Cardio'), provider),
                  _buildGrid(context, provider.getByCategory('Strength'), provider),
                  _buildGrid(context, provider.getByCategory('Flexibility'), provider),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WorkoutProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text('No routines yet', style: AppTextStyles.heading4),
            const SizedBox(height: 8),
            Text(
              'Workouts will appear here once you create them\nor they are added to the database.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.refreshWorkouts(),
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<Map<String, dynamic>> workouts, WorkoutProvider provider) {
    if (workouts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Text('No workouts in this category', style: AppTextStyles.bodyMedium),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () => provider.refreshWorkouts(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: workouts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.82,
          ),
          itemBuilder: (context, index) {
            final w = workouts[index];
            return _RoutineCard(
              id: w['id'] as String? ?? index.toString(),
              title: w['name'] as String? ?? 'Untitled',
              duration: w['duration'] as int? ?? 0,
              category: w['category'] as String? ?? 'General',
              difficulty: w['difficulty'] as String? ?? '',
              description: w['description'] as String? ?? '',
              exerciseCount: w['exercise_count'] as int? ?? (8 + (index % 5)),
              isCompleted: w['is_completed'] as bool? ?? false,
            );
          },
        ),
      ),
    );
  }
}

class _RoutineCard extends StatefulWidget {
  const _RoutineCard({
    required this.id,
    required this.title,
    required this.duration,
    required this.category,
    required this.difficulty,
    required this.description,
    required this.exerciseCount,
    this.isCompleted = false,
  });
  final String id;
  final String title;
  final int duration;
  final String category;
  final String difficulty;
  final String description;
  final int exerciseCount;
  final bool isCompleted;

  @override
  State<_RoutineCard> createState() => _RoutineCardState();
}

class _RoutineCardState extends State<_RoutineCard> {
  bool isFavorite = false;

  IconData get _categoryIcon {
    switch (widget.category.toLowerCase()) {
      case 'cardio':
        return Icons.directions_run;
      case 'strength':
        return Icons.fitness_center;
      case 'flexibility':
        return Icons.self_improvement;
      case 'core':
        return Icons.sports_gymnastics;
      case 'full body':
        return Icons.accessibility_new;
      default:
        return Icons.sports;
    }
  }

  Color get _difficultyColor {
    switch (widget.difficulty.toLowerCase()) {
      case 'beginner':
      case 'principiante':
        return AppColors.success;
      case 'intermediate':
      case 'intermedio':
        return Colors.orange;
      case 'advanced':
      case 'avanzado':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lp = context.read<LocaleProvider>();
    
    return Hero(
      tag: 'routine_${widget.id}',
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoutineDetailScreen(
                id: widget.id,
                title: widget.title,
                category: widget.category,
                difficulty: widget.difficulty,
                duration: widget.duration,
                exerciseCount: widget.exerciseCount,
                description: widget.description,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color ?? Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Container(
                      height: 110,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          _categoryIcon,
                          size: 44,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => isFavorite = !isFavorite),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  if (widget.isCompleted)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, size: 12, color: Colors.white),
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.exerciseCount} ${lp.translate('exercises')}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 12, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.duration} min',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (widget.difficulty.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _difficultyColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            lp.translate(widget.difficulty.toLowerCase()),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: _difficultyColor,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
