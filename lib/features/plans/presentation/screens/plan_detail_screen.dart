import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';
import 'package:fit_motiv/core/theme/theme_provider.dart';
import 'package:fit_motiv/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class PlanDetailScreen extends StatefulWidget {
  const PlanDetailScreen({super.key, required this.title});
  final String title;

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  int selectedDay = 0;
  final List<String> days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  @override
  Widget build(BuildContext context) {
    final l10n = context.watch<LocaleProvider>();
    final primaryColor = context.watch<ThemeProvider>().primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: isMobile ? AppTextStyles.heading4 : AppTextStyles.heading3),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined))],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day Selector
              SizedBox(
                height: isMobile ? 100 : 120,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 20, vertical: 20),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedDay == index;
                    return GestureDetector(
                      onTap: () => setState(() => selectedDay = index),
                      child: Container(
                        width: isMobile ? 60 : 80,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? primaryColor : (isDark ? Colors.white10 : Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: primaryColor.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                          border: isSelected ? null : Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              days[index],
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 14 : 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 18 : 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Macros Mini Dashboard
              Padding(
                padding: EdgeInsets.all(isMobile ? 20 : 0),
                child: Container(
                  padding: EdgeInsets.all(isMobile ? 20 : 40),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMacroIndicator(
                            l10n.translate('proteins'),
                            '120g',
                            0.8,
                            Colors.blue,
                            primaryColor,
                            isMobile,
                          ),
                          _buildMacroIndicator(
                            l10n.translate('carbs'),
                            '200g',
                            0.6,
                            Colors.orange,
                            primaryColor,
                            isMobile,
                          ),
                          _buildMacroIndicator(l10n.translate('fats'), '50g', 0.4, Colors.pink, primaryColor, isMobile),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Meals
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 0, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.translate('meal_plans'),
                      style: isMobile ? AppTextStyles.heading4 : AppTextStyles.heading3,
                    ),
                    const SizedBox(height: 16),
                    if (isMobile) ...[
                      _buildMealCard(
                        l10n.translate('breakfast'),
                        'Omelet de espinacas y aguacate',
                        '450 kcal',
                        Icons.egg_outlined,
                        primaryColor,
                      ),
                      _buildMealCard(
                        l10n.translate('lunch'),
                        'Pollo a la plancha con quinoa y brócoli',
                        '650 kcal',
                        Icons.restaurant_outlined,
                        primaryColor,
                      ),
                      _buildMealCard(
                        l10n.translate('snacks'),
                        'Yogurt griego con moras',
                        '200 kcal',
                        Icons.apple_outlined,
                        primaryColor,
                      ),
                      _buildMealCard(
                        l10n.translate('dinner'),
                        'Salmón al horno con espárragos',
                        '500 kcal',
                        Icons.set_meal_outlined,
                        primaryColor,
                      ),
                    ] else
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 2.5,
                        children: [
                          _buildMealCard(
                            l10n.translate('breakfast'),
                            'Omelet de espinacas',
                            '450 kcal',
                            Icons.egg_outlined,
                            primaryColor,
                          ),
                          _buildMealCard(
                            l10n.translate('lunch'),
                            'Pollo con quinoa',
                            '650 kcal',
                            Icons.restaurant_outlined,
                            primaryColor,
                          ),
                          _buildMealCard(
                            l10n.translate('snacks'),
                            'Yogurt griego',
                            '200 kcal',
                            Icons.apple_outlined,
                            primaryColor,
                          ),
                          _buildMealCard(
                            l10n.translate('dinner'),
                            'Salmón al horno',
                            '500 kcal',
                            Icons.set_meal_outlined,
                            primaryColor,
                          ),
                        ],
                      ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: primaryColor,
        icon: const Icon(Icons.shopping_basket_outlined, color: Colors.white),
        label: Text(
          l10n.translate('shopping_list'),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMacroIndicator(String label, String value, double percent, Color color, Color primary, bool isMobile) {
    double radius = isMobile ? 35.0 : 50.0;
    return Column(
      children: [
        CircularPercentIndicator(
          radius: radius,
          lineWidth: isMobile ? 8.0 : 12.0,
          percent: percent,
          center: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: isMobile ? 12 : 16),
          ),
          progressColor: color,
          backgroundColor: color.withValues(alpha: 0.1),
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: (isMobile ? AppTextStyles.bodySmall : AppTextStyles.bodyMedium).copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMealCard(String title, String description, String calories, IconData icon, Color primary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(color: primary, fontWeight: FontWeight.bold),
                ),
                Text(description, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(calories, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
