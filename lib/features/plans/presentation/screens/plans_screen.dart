import 'package:flutter/material.dart';
import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';

class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text('Nutrition', style: AppTextStyles.heading3),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Meal Plans'),
              Tab(text: 'Recipes'),
              Tab(text: 'Tips'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Personalized Meal Plan',
                    style: AppTextStyles.heading4,
                  ),
                  const SizedBox(height: 16),
                  const _MealPlanCard(),
                  const SizedBox(height: 32),
                  Text(
                    'Explore Healthy Recipes',
                    style: AppTextStyles.heading4,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _RecipePreviewCard(
                          title: 'Quick & Easy Salads',
                          imageUrl: 'https://via.placeholder.com/150',
                        ),
                        _RecipePreviewCard(
                          title: 'Lean Protein Dishes',
                          imageUrl: 'https://via.placeholder.com/150',
                        ),
                        _RecipePreviewCard(
                          title: 'Refreshing Smoothies',
                          imageUrl: 'https://via.placeholder.com/150',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Text('Recipes content', style: AppTextStyles.bodyLarge),
            ),
            Center(child: Text('Tips content', style: AppTextStyles.bodyLarge)),
          ],
        ),
      ),
    );
  }
}

class _MealPlanCard extends StatelessWidget {
  const _MealPlanCard();
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
          Text(
            'Week 1',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text('Balanced Diet for Weight Loss', style: AppTextStyles.heading3),
          const SizedBox(height: 8),
          Text(
            'A 7-day plan with delicious and nutritious meals to kickstart your journey.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text('View Plan', style: AppTextStyles.buttonText),
          ),
        ],
      ),
    );
  }
}

class _RecipePreviewCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  const _RecipePreviewCard({required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
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
            child: Image.network(
              imageUrl,
              height: 90,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(title, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}
