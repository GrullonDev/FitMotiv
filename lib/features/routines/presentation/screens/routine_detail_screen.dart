import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';
import 'package:fit_motiv/core/utils/responsive_utils.dart';
import 'package:fit_motiv/features/routines/domain/entities/exercise.dart';
import 'package:fit_motiv/features/routines/presentation/providers/workout_provider.dart';
import 'package:fit_motiv/features/routines/presentation/screens/workout_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoutineDetailScreen extends StatefulWidget {
  const RoutineDetailScreen({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.duration,
    required this.exerciseCount,
    this.description = '',
  });

  final String id;
  final String title;
  final String category;
  final String difficulty;
  final int duration;
  final int exerciseCount;
  final String description;

  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  int _selectedDuration = 70; // Default 70s as requested
  List<Map<String, dynamic>> _dbExercises = [];
  bool _loadingExercises = true;

  @override
  void initState() {
    super.initState();
    _loadExercisesFromSupabase();
  }

  Future<void> _loadExercisesFromSupabase() async {
    final provider = context.read<WorkoutProvider>();
    final exercises = await provider.loadExercises(widget.id);
    if (mounted) {
      setState(() {
        _dbExercises = exercises;
        _loadingExercises = false;
      });
    }
  }

  /// Genera la lista de Exercise entities para el player.
  /// Si hay ejercicios en DB, usa esos. Si no, genera fallback.
  List<Exercise> _buildExerciseList() {
    if (_dbExercises.isNotEmpty) {
      return _dbExercises
          .map(
            (e) => Exercise(
              id: e['id'] as String? ?? '',
              name: e['name'] as String? ?? 'Exercise',
              category: e['category'] as String? ?? widget.category,
              seconds: e['seconds'] as int? ?? _selectedDuration,
              reps: e['reps'] as int?,
              description: e['description'] as String? ?? 'Focus on your form.',
            ),
          )
          .toList();
    }

    // Fallback: generar ejercicios demo si la DB no tiene
    return List.generate(
      widget.exerciseCount,
      (index) => Exercise(
        id: 'ex_$index',
        name: [
          'Push Ups',
          'Squats',
          'Plank',
          'Lunges',
          'Jumping Jacks',
          'Burpees',
          'Mountain Climbers',
          'Crunches',
          'Dips',
          'Deadlift',
        ][index % 10],
        category: widget.category,
        seconds: _selectedDuration,
        reps: null,
        description: 'Focus on your form and keep a steady pace.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lp = context.read<LocaleProvider>();
    final isTablet = Responsive.isTablet(context);
    final exerciseCount = _dbExercises.isNotEmpty ? _dbExercises.length : widget.exerciseCount;

    if (isTablet) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title, style: AppTextStyles.heading4), centerTitle: true),
        body: Row(
          children: [
            // Left Column: Details & Settings
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroHeader(context),
                    const SizedBox(height: 32),
                    _buildRoutineSummary(context, lp),
                    const SizedBox(height: 32),
                    _buildTimerSettings(lp),
                    const SizedBox(height: 32),
                    _buildDescription(lp),
                    const SizedBox(height: 48),
                    _buildStartButton(context, lp),
                  ],
                ),
              ),
            ),
            VerticalDivider(width: 1, color: AppColors.border.withValues(alpha: 0.5)),
            // Right Column: Exercises
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      '${lp.translate('exercises').toUpperCase()} ($exerciseCount)',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _loadingExercises
                        ? Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: exerciseCount,
                            itemBuilder: (context, index) => _ExerciseTile(
                              index: index,
                              name: _dbExercises.isNotEmpty
                                  ? _dbExercises[index]['name'] as String? ?? 'Exercise'
                                  : null,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(background: _buildHeroHeader(context)),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRoutineSummary(context, lp),
                  const SizedBox(height: 24),
                  _buildTimerSettings(lp),
                  const SizedBox(height: 24),
                  _buildDescription(lp),
                  const SizedBox(height: 24),
                  Text(
                    '${lp.translate('exercises').toUpperCase()} ($exerciseCount)',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          if (_loadingExercises)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _ExerciseTile(
                  index: index,
                  name: _dbExercises.isNotEmpty ? _dbExercises[index]['name'] as String? ?? 'Exercise' : null,
                ),
                childCount: exerciseCount,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: _buildStartButton(context, lp),
      ),
    );
  }

  Widget _buildTimerSettings(LocaleProvider lp) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timer_outlined, color: Theme.of(context).colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                lp.translate('workout_settings'),
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lp.translate('exercise_duration'), style: AppTextStyles.bodySmall),
              Row(
                children: [
                  _IconButton(
                    icon: Icons.remove,
                    onPressed: _selectedDuration > 10 ? () => setState(() => _selectedDuration -= 5) : null,
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 60,
                    child: Text(
                      '$_selectedDuration${lp.translate('sec_short')}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _IconButton(icon: Icons.add, onPressed: () => setState(() => _selectedDuration += 5)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Hero(
      tag: 'routine_${widget.id}',
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
            ],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(_getCategoryIcon(widget.category), size: 100, color: Colors.white.withValues(alpha: 0.3)),
            ),
            Positioned(
              top: 20,
              right: 16,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share, color: Colors.white),
                style: IconButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: 0.3)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineSummary(BuildContext context, LocaleProvider lp) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title, style: AppTextStyles.heading4),
              const SizedBox(height: 4),
              Text(
                '${lp.translate(widget.category.toLowerCase())} • ${widget.duration} min',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        _buildDifficultyTag(context, lp),
      ],
    );
  }

  Widget _buildDescription(LocaleProvider lp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lp.translate('description') == 'description' ? 'Description' : lp.translate('description'),
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          widget.description.isNotEmpty
              ? widget.description
              : 'This routine is designed to help you reach your goals with a mix of targeted exercises.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context, LocaleProvider lp) {
    return ElevatedButton(
      onPressed: () {
        final exercises = _buildExerciseList();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutPlayerScreen(exercises: exercises, routineTitle: widget.title),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.play_arrow_rounded),
          const SizedBox(width: 8),
          Text(
            lp.translate('start_now'),
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyTag(BuildContext context, LocaleProvider lp) {
    Color color;
    switch (widget.difficulty.toLowerCase()) {
      case 'beginner':
      case 'principiante':
        color = AppColors.success;
        break;
      case 'intermediate':
      case 'intermedio':
        color = Colors.orange;
        break;
      case 'advanced':
      case 'avanzado':
        color = AppColors.error;
        break;
      default:
        color = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(
        lp.translate(widget.difficulty.toLowerCase()),
        style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cardio':
        return Icons.directions_run;
      case 'strength':
      case 'fuerza':
        return Icons.fitness_center;
      case 'flexibility':
      case 'flexibilidad':
        return Icons.self_improvement;
      default:
        return Icons.fitness_center;
    }
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, this.onPressed});
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: onPressed == null ? 0.05 : 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: onPressed == null ? 0.3 : 1.0),
          size: 18,
        ),
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile({required this.index, this.name});
  final int index;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final exerciseNames = [
      'Push Ups',
      'Squats',
      'Plank',
      'Lunges',
      'Jumping Jacks',
      'Burpees',
      'Mountain Climbers',
      'Crunches',
      'Dips',
      'Deadlift',
    ];
    final displayName = name ?? exerciseNames[index % exerciseNames.length];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(displayName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          ),
          Icon(Icons.timer_outlined, color: AppColors.textSecondary, size: 20),
        ],
      ),
    );
  }
}
