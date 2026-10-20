import 'dart:math';

import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';

import 'package:fit_motiv/features/profile_settings/presentation/screens/settings_screen.dart';

import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/models/sample_data.dart';
import 'package:fit_motiv/widgets/progress_card.dart';
import 'package:fit_motiv/widgets/recipe_card.dart';
import 'package:fit_motiv/widgets/workout_card.dart';
import 'package:fit_motiv/features/assistant/presentation/screens/assistant_chat_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late String dailyQuote;

  @override
  void initState() {
    super.initState();
    final random = Random();
    dailyQuote =
        SampleData.motivationalQuotes[random.nextInt(
          SampleData.motivationalQuotes.length,
        )];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AssistantChatScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.psychology, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 30),
              _buildProgressSection(),
              const SizedBox(height: 30),
              _buildQuoteSection(),
              const SizedBox(height: 30),
              _buildWorkoutSection(),
              const SizedBox(height: 30),
              _buildRecipeSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back,', style: AppTextStyles.welcome),
              const SizedBox(height: 4),
              Text('Amelia', style: AppTextStyles.heading1),
            ],
          ),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
              child: const Icon(
                Icons.settings,
                size: 24,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 200),
      child: const ProgressCard(),
    );
  }

  Widget _buildQuoteSection() {
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
              '"$dailyQuote"',
              textAlign: TextAlign.center,
              style: AppTextStyles.quote,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutSection() {
    return FadeInUp(
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
  }

  Widget _buildRecipeSection() {
    return FadeInUp(
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


}
