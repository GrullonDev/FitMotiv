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
              imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=500&auto=format&fit=crop',
              isRecommended: true,
            ),
            const SizedBox(height: 16),
            NutritionPlanCard(
              title: l10n.translate('muscle_building'),
              description: l10n.translate('muscle_building_desc'),
              calories: '2,500 - 3,000 kcal',
              icon: Icons.fitness_center,
              badgeText: l10n.translate('advanced'),
              imageUrl: 'https://images.unsplash.com/photo-1532384748853-8f54a8f476e2?q=80&w=500&auto=format&fit=crop',
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
                    imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=500&auto=format&fit=crop',
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
                    imageUrl: 'https://images.unsplash.com/photo-1532384748853-8f54a8f476e2?q=80&w=500&auto=format&fit=crop',
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
              _buildFilterChip(l10n.translate('fast'), false, primaryColor),
              _buildFilterChip(l10n.translate('keto'), false, primaryColor),
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
            children: [
              RecipeCard(
                title: l10n.translate('avocado_toast'),
                time: '15 min',
                calories: '320 kcal',
                imageUrl:
                    'https://images.unsplash.com/photo-1525351484163-7529414344d8?q=80&w=500&auto=format&fit=crop',
              ),
              RecipeCard(
                title: l10n.translate('quinoa_salad'),
                time: '20 min',
                calories: '450 kcal',
                imageUrl:
                    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=500&auto=format&fit=crop',
              ),
              RecipeCard(
                title: l10n.translate('berry_smoothie'),
                time: '5 min',
                calories: '250 kcal',
                imageUrl:
                    'https://images.unsplash.com/photo-1553530666-ba11a7da3888?q=80&w=500&auto=format&fit=crop',
              ),
              RecipeCard(
                title: l10n.translate('grilled_salmon'),
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
                  context,
                  'Mito: Los carbohidratos después de las 6 PM engordan.',
                  'Realidad: El balance calórico total del día es lo que importa.',
                  const Color(0xFF3B82F6),
                  primaryColor,
                ),
                _buildMythCard(
                  context,
                  'Mito: Beber agua con limón quema grasa.',
                  'Realidad: El agua con limón hidrata, pero no tiene propiedades quema grasa.',
                  const Color(0xFFF59E0B),
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
          Text(l10n.translate('recommended_articles'), style: AppTextStyles.heading4),
          const SizedBox(height: 16),
          _buildArticleTile(
            'Cómo leer etiquetas nutricionales',
            'Aprende a diferenciar el marketing de la realidad.',
            '5 ${l10n.translate('read_time')}',
          ),
          _buildArticleTile(
            'La importancia de la hidratación',
            'Por qué el agua es tu mejor aliada en el gym.',
            '4 ${l10n.translate('read_time')}',
          ),
          _buildArticleTile('Mejores snacks pre-entreno', 'Energía real para tus músculos.', '3 ${l10n.translate('read_time')}'),
          const SizedBox(height: 80), // Added bottom padding to ensure final card is visible
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
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
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
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.3),
                ),
                const SizedBox(height: 6),
                Text(description, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13, height: 1.4)),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: IconButton(
              onPressed: () {
                // Future: Add Share logic
              },
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
                onPressed: () {
                  setState(() {
                    if (glassesValue < 20) {
                      glassesValue++;
                    }
                  });
                },
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
                  color: isDrunk ? (isComplete ? Colors.green : Colors.blue) : AppColors.textSecondary.withValues(alpha: 0.3),
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
