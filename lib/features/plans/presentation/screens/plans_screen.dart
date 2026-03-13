import 'package:flutter/material.dart';
import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';

class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.watch<LocaleProvider>().translate('nutrition'), style: AppTextStyles.heading3),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Meal Plans'),
              Tab(text: 'Recipes'),
              Tab(text: 'Tips'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMealPlansTab(),
            _buildRecipesTab(),
            _buildTipsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildMealPlansTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personalized Meal Plans', style: AppTextStyles.heading4),
          const SizedBox(height: 16),
          const _MealPlanCard(
            title: 'Weight Loss Plan',
            description: 'Focus on calorie deficit and high protein.',
            calories: '1,500 - 1,800 kcal',
          ),
          const SizedBox(height: 16),
          const _MealPlanCard(
            title: 'Muscle Building',
            description: 'High carb and high protein for bulk.',
            calories: '2,500 - 3,000 kcal',
          ),
        ],
      ),
    );
  }

  Widget _buildRecipesTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        _RecipePreviewCard(
          title: 'Avocado Toast with Egg',
          time: '15 min',
          calories: '320 kcal',
          imageUrl: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?q=80&w=500&auto=format&fit=crop',
        ),
        SizedBox(height: 16),
        _RecipePreviewCard(
          title: 'Quinoa Salad',
          time: '20 min',
          calories: '450 kcal',
          imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=500&auto=format&fit=crop',
        ),
      ],
    );
  }

  Widget _buildTipsTab() {
    return const Center(child: Text('Coming Soon...'));
  }
}

class _MealPlanCard extends StatelessWidget {
  const _MealPlanCard({
    required this.title,
    required this.description,
    required this.calories,
  });

  final String title;
  final String description;
  final String calories;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.heading4.copyWith(color: AppColors.primary)),
          const SizedBox(height: 8),
          Text(description, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 8),
          Text(calories, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('View Plan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _RecipePreviewCard extends StatelessWidget {
  const _RecipePreviewCard({
    required this.title,
    required this.time,
    required this.calories,
    required this.imageUrl,
  });

  final String title;
  final String time;
  final String calories;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 150,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: AppColors.surface),
                    child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150,
                  decoration: const BoxDecoration(color: AppColors.surface),
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, color: AppColors.primary),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
