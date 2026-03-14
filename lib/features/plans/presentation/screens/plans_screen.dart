import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';
import 'package:fit_motiv/core/theme/theme_provider.dart';
import 'package:fit_motiv/core/utils/responsive_utils.dart';
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
    bool isMobile = Responsive.isMobile(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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
          if (isMobile) ...[
            NutritionPlanCard(
              title: l10n.translate('weight_loss_plan'),
              description: l10n.translate('weight_loss_desc'),
              calories: '1,500 - 1,800 kcal',
              icon: Icons.restaurant,
              badgeText: '7 ${l10n.translate('days')}',
              isRecommended: true,
            ),
            const SizedBox(height: 16),
            NutritionPlanCard(
              title: l10n.translate('muscle_building'),
              description: l10n.translate('muscle_building_desc'),
              calories: '2,500 - 3,000 kcal',
              icon: Icons.fitness_center,
              badgeText: l10n.translate('advanced'),
              isRecommended: false,
            ),
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: NutritionPlanCard(
                    title: l10n.translate('weight_loss_plan'),
                    description: l10n.translate('weight_loss_desc'),
                    calories: '1,500 - 1,800 kcal',
                    icon: Icons.restaurant,
                    badgeText: '7 ${l10n.translate('days')}',
                    isRecommended: true,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: NutritionPlanCard(
                    title: l10n.translate('muscle_building'),
                    description: l10n.translate('muscle_building_desc'),
                    calories: '2,500 - 3,000 kcal',
                    icon: Icons.fitness_center,
                    badgeText: l10n.translate('advanced'),
                    isRecommended: false,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRecipesTab(BuildContext context, LocaleProvider l10n, Color primaryColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);

    return Column(
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

        // Category Chips
        SizedBox(
          height: 50,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 36),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildFilterChip(l10n.translate('vegan'), true, primaryColor),
              _buildFilterChip(l10n.translate('high_protein'), false, primaryColor),
              _buildFilterChip(l10n.translate('easy'), false, primaryColor),
              _buildFilterChip('Keto', false, primaryColor),
            ],
          ),
        ),

        Expanded(
          child: GridView.count(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(isMobile ? 20 : 40),
            crossAxisCount: isMobile ? 2 : 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: isMobile ? 0.68 : 0.85,
            children: const [
              RecipeCard(
                title: 'Avocado Toast',
                time: '15 min',
                calories: '320 kcal',
                imageUrl:
                    'https://images.unsplash.com/photo-1525351484163-7529414344d8?q=80&w=500&auto=format&fit=crop',
              ),
              RecipeCard(
                title: 'Quinoa Salad',
                time: '20 min',
                calories: '450 kcal',
                imageUrl:
                    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=500&auto=format&fit=crop',
              ),
              RecipeCard(
                title: 'Berry Smoothie',
                time: '5 min',
                calories: '250 kcal',
                imageUrl:
                    'https://images.unsplash.com/photo-1536304953400-025545a99971?q=80&w=500&auto=format&fit=crop',
              ),
              RecipeCard(
                title: 'Grilled Salmon',
                time: '25 min',
                calories: '550 kcal',
                imageUrl:
                    'https://images.unsplash.com/photo-1467003909585-2f8a72700288?q=80&w=500&auto=format&fit=crop',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, Color primary) {
    return Container(
      margin: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (v) {},
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

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carrusel - Sabías que?
          Text(l10n.translate('did_you_know'), style: AppTextStyles.heading4),
          const SizedBox(height: 16),
          SizedBox(
            height: 190,
            child: PageView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildMythCard(
                  'Mito: Los carbohidratos después de las 6 PM engordan.',
                  'Realidad: El balance calórico total del día es lo que importa.',
                  Colors.blue,
                  primaryColor,
                ),
                _buildMythCard(
                  'Mito: Beber agua con limón quema grasa.',
                  'Realidad: El agua con limón hidrata, pero no tiene propiedades quema grasa.',
                  Colors.orange,
                  primaryColor,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Water Calculator
          Text(l10n.translate('water_tracker'), style: AppTextStyles.heading4),
          const SizedBox(height: 16),
          const _WaterTrackerWidget(),

          const SizedBox(height: 32),

          // Articles
          Text('Artículos Recomendados', style: AppTextStyles.heading4),
          const SizedBox(height: 16),
          _buildArticleTile(
            'Cómo leer etiquetas nutricionales',
            'Aprende a diferenciar el marketing de la realidad.',
            '5 min lectura',
          ),
          _buildArticleTile(
            'La importancia de la hidratación',
            'Por qué el agua es tu mejor aliada en el gym.',
            '4 min lectura',
          ),
          _buildArticleTile('Mejores snacks pre-entreno', 'Energía real para tus músculos.', '3 min lectura'),
        ],
      ),
    );
  }

  Widget _buildMythCard(String title, String description, Color color, Color primary) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withValues(alpha: 0.8), color]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(), // Only scroll if absolutely necessary
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb_outline, color: Colors.white, size: 28),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(description, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
          ],
        ),
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
}

class _WaterTrackerWidget extends StatefulWidget {
  const _WaterTrackerWidget();

  @override
  State<_WaterTrackerWidget> createState() => _WaterTrackerWidgetState();
}

class _WaterTrackerWidgetState extends State<_WaterTrackerWidget> {
  int glassesValue = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.watch<LocaleProvider>();
    final primaryColor = context.watch<ThemeProvider>().primaryColor;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$glassesValue / 8 ${l10n.translate('glasses')}',
                    style: AppTextStyles.heading3.copyWith(color: primaryColor),
                  ),
                  Text(l10n.translate('water_target'), style: AppTextStyles.bodySmall),
                ],
              ),
              IconButton.filled(
                onPressed: () => setState(() {
                  if (glassesValue < 20) glassesValue++;
                }),
                style: IconButton.styleFrom(backgroundColor: primaryColor),
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(8, (index) {
              return Icon(
                index < glassesValue ? Icons.water_drop : Icons.water_drop_outlined,
                color: index < glassesValue ? Colors.blue : AppColors.textSecondary.withValues(alpha: 0.5),
                size: 28,
              );
            }),
          ),
        ],
      ),
    );
  }
}
