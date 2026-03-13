
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:fit_motiv/features/profile_settings/presentation/providers/user_profile_provider.dart';
import 'package:fit_motiv/features/profile_settings/presentation/screens/settings_screen.dart';
import 'package:fit_motiv/widgets/progress_card.dart';
import 'package:fit_motiv/widgets/recipe_card.dart';
import 'package:fit_motiv/widgets/workout_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          final profileProvider = context.read<UserProfileProvider>();
          final dashboardProvider = context.read<DashboardProvider>();
          
          await profileProvider.refreshProfile();
          await dashboardProvider.fetchQuote();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildUserStatsRow(context),
              const SizedBox(height: 24),
              _buildProgressSection(),
              const SizedBox(height: 24),
              _buildQuoteSection(context),
              const SizedBox(height: 24),
              _buildWorkoutSection(),
              const SizedBox(height: 24),
              _buildRecipeSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final profileProvider = context.watch<UserProfileProvider>();
    final profile = profileProvider.profile;
    final firstName = profile != null
        ? profile.displayName.split(' ').first
        : 'User';

    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back,', style: AppTextStyles.welcome),
                const SizedBox(height: 4),
                Text(
                  firstName,
                  style: AppTextStyles.heading1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(
            children: [
              // Avatar con initiales del usuario
              if (profile != null)
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        profile.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(12),
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
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  ),
                  child: const Icon(
                    Icons.settings,
                    size: 24,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Muestra stats rápidas del usuario (datos del perfil de Supabase)
  Widget _buildUserStatsRow(BuildContext context) {
    final profile = context.watch<UserProfileProvider>().profile;

    if (profile == null) return const SizedBox.shrink();

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 100),
      child: Row(
        children: [
          if (profile.weight > 0)
            Expanded(
              child: _MiniStatCard(
                icon: Icons.monitor_weight_outlined,
                label: 'Weight',
                value: '${profile.weight.toStringAsFixed(1)} lbs',
                color: const Color(0xFF4ECDC4),
              ),
            ),
          if (profile.weight > 0 && profile.height > 0)
            const SizedBox(width: 12),
          if (profile.height > 0)
            Expanded(
              child: _MiniStatCard(
                icon: Icons.height,
                label: 'Height',
                value: '${profile.height.toStringAsFixed(2)} m',
                color: const Color(0xFF45B7D1),
              ),
            ),
          if ((profile.weight > 0 || profile.height > 0) && profile.fitnessGoal.isNotEmpty)
            const SizedBox(width: 12),
          if (profile.fitnessGoal.isNotEmpty)
            Expanded(
              child: _MiniStatCard(
                icon: Icons.flag_outlined,
                label: 'Goal',
                value: profile.fitnessGoal,
                color: const Color(0xFFFF6B6B),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() => FadeInUp(
    duration: const Duration(milliseconds: 600),
    delay: const Duration(milliseconds: 200),
    child: const ProgressCard(),
  );

  Widget _buildQuoteSection(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();
    final quoteText = dashboardProvider.quote?.text ?? 'Loading...';

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 400),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppColors.quoteGradient,
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
          children: [
            Icon(Icons.format_quote, size: 40, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              '"$quoteText"',
              textAlign: TextAlign.center,
              style: AppTextStyles.quote,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutSection() => FadeInUp(
    duration: const Duration(milliseconds: 600),
    delay: const Duration(milliseconds: 600),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Workout of the Day', style: AppTextStyles.heading3),
        const SizedBox(height: 16),
        const WorkoutCard(),
      ],
    ),
  );

  Widget _buildRecipeSection() => FadeInUp(
    duration: const Duration(milliseconds: 600),
    delay: const Duration(milliseconds: 800),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Healthy Recipe', style: AppTextStyles.heading3),
        const SizedBox(height: 16),
        const RecipeCard(),
      ],
    ),
  );
}

/// Card pequeña para stats rápidas
class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
