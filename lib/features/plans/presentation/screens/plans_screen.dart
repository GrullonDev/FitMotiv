import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';
import 'package:fit_motiv/core/theme/theme_provider.dart';
import 'package:fit_motiv/core/utils/responsive_utils.dart';
import 'package:fit_motiv/features/plans/presentation/providers/plans_provider.dart';
import 'package:fit_motiv/features/plans/presentation/widgets/nutrition_plan_card.dart';
import 'package:fit_motiv/features/plans/presentation/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.watch<LocaleProvider>();
    final primaryColor = context.watch<ThemeProvider>().primaryColor;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: Responsive.isMobile(context) ? 80 : 100,
          centerTitle: false,
          title: Padding(
            padding: EdgeInsets.only(
              left: Responsive.isMobile(context) ? 8.0 : 20.0,
              top: Responsive.isMobile(context) ? 16.0 : 24.0,
            ),
            child: Text(
              l10n.translate('nutrition'),
              style: (Responsive.isMobile(context) ? AppTextStyles.heading2 : AppTextStyles.heading1).copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          bottom: TabBar(
            labelColor: primaryColor,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            indicatorColor: primaryColor,
            indicatorWeight: 4,
            isScrollable: Responsive.isMobile(context) ? false : true,
            labelStyle: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            unselectedLabelStyle: AppTextStyles.bodyMedium,
            tabs: [
              Tab(text: l10n.translate('meal_plans')),
              Tab(text: l10n.translate('recipes')),
              Tab(text: l10n.translate('tips')),
            ],
          ),
        ),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: [
            _buildMealPlansTab(context, l10n, primaryColor),
            _buildRecipesTab(context, l10n, primaryColor),
            _buildTipsTab(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildMealPlansTab(BuildContext context, LocaleProvider l10n, Color primaryColor) {
    final provider = context.watch<PlansProvider>();
    bool isMobile = Responsive.isMobile(context);

    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }

    final plans = provider.mealPlans;

    return RefreshIndicator(
      color: primaryColor,
      onRefresh: () => provider.refreshAll(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(isMobile ? 20 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: primaryColor, size: isMobile ? 20 : 24),
                const SizedBox(width: 8),
                Text(
                  l10n.translate('personalized_meal_plans'),
                  style: isMobile ? AppTextStyles.heading4 : AppTextStyles.heading3,
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (plans.isEmpty)
              _buildEmptyState(
                context,
                'No hay planes disponibles',
                'Los planes de nutrición aparecerán aquí.',
                Icons.restaurant_menu,
              )
            else if (isMobile)
              ...plans.map(
                (plan) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: NutritionPlanCard(
                    title: plan['title'] as String? ?? '',
                    description: plan['description'] as String? ?? '',
                    calories: plan['calories'] as String? ?? '',
                    icon: _getIconForString(plan['icon'] as String? ?? 'restaurant'),
                    badgeText: plan['badge_text'] as String? ?? '',
                    imageUrl: plan['image_url'] as String? ?? '',
                    isRecommended: plan['is_recommended'] as bool? ?? false,
                  ),
                ),
              )
            else
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: plans
                    .map(
                      (plan) => SizedBox(
                        width: (MediaQuery.of(context).size.width - 84) / 2,
                        child: NutritionPlanCard(
                          title: plan['title'] as String? ?? '',
                          description: plan['description'] as String? ?? '',
                          calories: plan['calories'] as String? ?? '',
                          icon: _getIconForString(plan['icon'] as String? ?? 'restaurant'),
                          badgeText: plan['badge_text'] as String? ?? '',
                          imageUrl: plan['image_url'] as String? ?? '',
                          isRecommended: plan['is_recommended'] as bool? ?? false,
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipesTab(BuildContext context, LocaleProvider l10n, Color primaryColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);
    final provider = context.watch<PlansProvider>();

    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }

    final recipes = provider.filteredRecipes;
    final categories = provider.availableCategories;

    return RefreshIndicator(
      color: primaryColor,
      onRefresh: () => provider.refreshAll(),
      child: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.fromLTRB(isMobile ? 20 : 40, 20, isMobile ? 20 : 40, 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.translate('search_recipes'),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? Colors.white10 : Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Category Chips desde Supabase
          if (categories.isNotEmpty)
            SizedBox(
              height: 50,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 36),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: categories
                    .map(
                      (cat) => _buildFilterChip(
                        cat,
                        provider.selectedCategory == cat,
                        primaryColor,
                        () => provider.selectCategory(cat),
                      ),
                    )
                    .toList(),
              ),
            ),

          Expanded(
            child: recipes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant_menu, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.3)),
                        const SizedBox(height: 12),
                        Text('No hay recetas', style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  )
                : GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(isMobile ? 20 : 40),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 2 : 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: isMobile ? 0.68 : 0.85,
                    ),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return RecipeCard(
                        title: recipe['title'] as String? ?? '',
                        time: recipe['time'] as String? ?? '',
                        calories: recipe['calories'] as String? ?? '',
                        imageUrl: recipe['image_url'] as String? ?? '',
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, Color primary, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.transparent,
        selectedColor: primary.withValues(alpha: 0.2),
        checkmarkColor: primary,
        labelStyle: TextStyle(
          color: isSelected ? primary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: StadiumBorder(side: BorderSide(color: isSelected ? primary : AppColors.border)),
      ),
    );
  }

  Widget _buildTipsTab(BuildContext context, LocaleProvider l10n) {
    final primaryColor = context.watch<ThemeProvider>().primaryColor;
    final provider = context.watch<PlansProvider>();

    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }

    return RefreshIndicator(
      color: primaryColor,
      onRefresh: () => provider.refreshAll(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carrusel - Sabías que? — desde Supabase
            Text(l10n.translate('did_you_know'), style: AppTextStyles.heading4),
            const SizedBox(height: 16),
            if (provider.tips.isEmpty)
              _buildEmptyState(context, 'Sin tips', 'Los tips nutricionales aparecerán aquí.', Icons.lightbulb_outline)
            else
              SizedBox(
                height: 190,
                child: PageView(
                  physics: const BouncingScrollPhysics(),
                  children: provider.tips.map((tip) {
                    final color = _parseColor(tip['color'] as String? ?? '#3B82F6');
                    return _buildMythCard(
                      context,
                      tip['title'] as String? ?? '',
                      tip['description'] as String? ?? '',
                      color,
                      primaryColor,
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 32),

            // Water Calculator — persistido en Supabase
            Text(l10n.translate('water_tracker'), style: AppTextStyles.heading4),
            const SizedBox(height: 16),
            _WaterTrackerWidget(provider: provider),

            const SizedBox(height: 32),

            // Articles — desde Supabase
            Text(l10n.translate('recommended_articles'), style: AppTextStyles.heading4),
            const SizedBox(height: 16),
            if (provider.articles.isEmpty)
              _buildEmptyState(
                context,
                'Sin artículos',
                'Los artículos recomendados aparecerán aquí.',
                Icons.article_outlined,
              )
            else
              ...provider.articles.map(
                (article) => _buildArticleTile(
                  article['title'] as String? ?? '',
                  article['subtitle'] as String? ?? '',
                  article['read_time'] as String? ?? '',
                ),
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String title, String subtitle, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
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

  Widget _buildMythCard(BuildContext context, String title, String description, Color color, Color primary) {
    final l10n = context.read<LocaleProvider>();
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.8), color],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.white, size: 28),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: IconButton(
              onPressed: () {},
              style: IconButton.styleFrom(
                backgroundColor: Colors.white12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.share_outlined, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    l10n.translate('share'),
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleTile(String title, String subtitle, String readTime) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Text(
                  readTime,
                  style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF3B82F6);
    }
  }

  IconData _getIconForString(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'restaurant':
        return Icons.restaurant;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'eco':
        return Icons.eco;
      case 'local_fire_department':
        return Icons.local_fire_department;
      default:
        return Icons.restaurant;
    }
  }
}

/// Water Tracker conectado a Supabase (persiste los vasos)
class _WaterTrackerWidget extends StatelessWidget {
  const _WaterTrackerWidget({required this.provider});
  final PlansProvider provider;

  @override
  Widget build(BuildContext context) {
    final l10n = context.watch<LocaleProvider>();
    final primaryColor = context.watch<ThemeProvider>().primaryColor;

    final glassesValue = provider.todayWaterGlasses;
    bool isComplete = glassesValue >= 8;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isComplete ? Colors.green.withValues(alpha: 0.1) : primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isComplete ? Colors.green.withValues(alpha: 0.3) : primaryColor.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: AppTextStyles.heading3.copyWith(
                      color: isComplete ? Colors.green : primaryColor,
                      fontWeight: FontWeight.w900,
                    ),
                    child: Text('$glassesValue / 8 ${l10n.translate('glasses')}'),
                  ),
                  Text(
                    isComplete ? l10n.translate('water_reached') : l10n.translate('water_target'),
                    style: TextStyle(
                      color: isComplete ? Colors.green : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              IconButton.filled(
                onPressed: () => provider.addWaterGlass(),
                style: IconButton.styleFrom(
                  backgroundColor: isComplete ? Colors.green : primaryColor,
                  padding: const EdgeInsets.all(12),
                ),
                icon: const Icon(Icons.add, color: Colors.white, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(8, (index) {
              bool isDrunk = index < glassesValue;
              return AnimatedScale(
                scale: isDrunk ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
                child: Icon(
                  isDrunk ? Icons.water_drop : Icons.water_drop_outlined,
                  color: isDrunk
                      ? (isComplete ? Colors.green : Colors.blue)
                      : AppColors.textSecondary.withValues(alpha: 0.3),
                  size: 30,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
