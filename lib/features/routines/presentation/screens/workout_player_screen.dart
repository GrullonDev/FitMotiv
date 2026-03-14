import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';
import 'package:fit_motiv/core/utils/responsive_utils.dart';
import 'package:fit_motiv/features/progress/presentation/providers/progress_provider.dart';
import 'package:fit_motiv/features/routines/domain/entities/exercise.dart';
import 'package:fit_motiv/features/routines/presentation/providers/workout_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class WorkoutPlayerScreen extends StatefulWidget {
  final List<Exercise> exercises;
  final String routineTitle;

  const WorkoutPlayerScreen({
    super.key,
    required this.exercises,
    required this.routineTitle,
  });

  @override
  State<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutSessionProvider>().startWorkout(widget.exercises);
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<WorkoutSessionProvider>();
    final lp = context.read<LocaleProvider>();

    if (session.state == WorkoutState.completed) {
      return _buildCompletionScreen(context, lp);
    }

    if (session.exercises.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentExercise = session.currentExercise;
    final isRest = session.state == WorkoutState.rest;
    final isTablet = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: isRest ? const Color(0xFFE8F5E9) : AppColors.background,
      appBar: AppBar(
        backgroundColor: isRest ? const Color(0xFFE8F5E9) : null,
        title: Text(isRest ? lp.translate('rest') : widget.routineTitle, style: AppTextStyles.heading4),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _confirmExit(context, lp),
        ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: session.progress,
            backgroundColor: AppColors.border,
            color: isRest ? Colors.green : Theme.of(context).colorScheme.primary,
          ),
          Expanded(
            child: isTablet 
              ? _buildTabletLayout(context, session, currentExercise, isRest, lp)
              : _buildMobileLayout(context, session, currentExercise, isRest, lp),
          ),
          _buildControls(context, session),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, WorkoutSessionProvider session, Exercise currentExercise, bool isRest, LocaleProvider lp) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildExerciseVisual(context, currentExercise, isRest),
          const SizedBox(height: 40),
          _buildExerciseInfo(context, session, currentExercise, isRest, lp),
          const SizedBox(height: 20),
          if (!isRest && session.currentIndex < session.exercises.length - 1) _buildNextPreview(lp, session),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, WorkoutSessionProvider session, Exercise currentExercise, bool isRest, LocaleProvider lp) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildExerciseVisual(context, currentExercise, isRest, size: 300),
          ),
          const SizedBox(width: 40),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildExerciseInfo(context, session, currentExercise, isRest, lp),
                const SizedBox(height: 40),
                if (!isRest && session.currentIndex < session.exercises.length - 1) _buildNextPreview(lp, session),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseVisual(BuildContext context, Exercise currentExercise, bool isRest, {double size = 200}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: (isRest ? Colors.green : Theme.of(context).colorScheme.primary).withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isRest ? Icons.timer : _getCategoryIcon(currentExercise.category),
        size: size / 2,
        color: isRest ? Colors.green : Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildExerciseInfo(BuildContext context, WorkoutSessionProvider session, Exercise currentExercise, bool isRest, LocaleProvider lp) {
    return Column(
      children: [
        Text(
          isRest ? lp.translate('get_ready_for_next') : currentExercise.name,
          style: AppTextStyles.heading2.copyWith(fontSize: 28),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        if (!currentExercise.isTimeBased && !isRest)
          Text(
            '${currentExercise.reps} reps',
            style: AppTextStyles.heading1.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
        const SizedBox(height: 24),
        _buildTimerProgress(context, session, isRest, currentExercise, lp),
        const SizedBox(height: 40),
        if (isRest)
          Text(
            '${lp.translate('next')}: ${session.exercises[session.currentIndex + 1].name}',
            style: AppTextStyles.heading4.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              currentExercise.description ?? 'Keep pushing! You are doing great.',
              style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget _buildTimerProgress(BuildContext context, WorkoutSessionProvider session, bool isRest, Exercise currentExercise, LocaleProvider lp) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: CircularProgressIndicator(
            value: session.timerProgress,
            strokeWidth: 10,
            strokeCap: StrokeCap.round,
            backgroundColor: AppColors.border.withValues(alpha: 0.3),
            color: isRest ? Colors.green : Theme.of(context).colorScheme.primary,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${session.remainingSeconds}',
              style: AppTextStyles.heading1.copyWith(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: isRest ? Colors.green : AppColors.textPrimary,
              ),
            ),
            Text(
              currentExercise.isTimeBased || isRest ? lp.translate('sec') : lp.translate('pace'),
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNextPreview(LocaleProvider lp, WorkoutSessionProvider session) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${lp.translate('next')}: ', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
          Text(
            session.exercises[session.currentIndex + 1].name,
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context, WorkoutSessionProvider session) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: session.currentIndex > 0 ? () => session.previousExercise() : null,
            icon: const Icon(Icons.skip_previous, size: 32),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              session.togglePause();
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                session.state == WorkoutState.paused ? Icons.play_arrow : Icons.pause,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          IconButton(
            onPressed: () => session.nextExercise(),
            icon: const Icon(Icons.skip_next, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen(BuildContext context, LocaleProvider lp) {
    final session = context.read<WorkoutSessionProvider>();
    
    // Log workout session once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgressProvider>().logWorkoutSession(
        workoutId: 'manual',
        workoutName: widget.routineTitle,
        durationMinutes: session.totalDurationMinutes > 0 ? session.totalDurationMinutes : 1,
        caloriesBurned: (session.totalDurationMinutes > 0 ? session.totalDurationMinutes : 1) * 7,
      );
    });

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
              const SizedBox(height: 24),
              Text(lp.translate('completed'), style: AppTextStyles.heading1),
              const SizedBox(height: 16),
              Text(
                'Great job! You finished the workout.',
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(lp.translate('finish')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmExit(BuildContext context, LocaleProvider lp) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lp.translate('quit_workout')),
        content: Text(lp.translate('quit_workout_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(lp.translate('continue')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close player
            },
            child: Text(lp.translate('quit'), style: const TextStyle(color: Colors.red)),
          ),
        ],
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
        return Icons.bolt;
    }
  }
}
