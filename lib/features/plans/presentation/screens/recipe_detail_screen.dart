import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/core/di/injection_container.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';
import 'package:fit_motiv/core/services/analytics_service.dart';
import 'package:fit_motiv/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.calories,
    required this.time,
  });

  final String title;
  final String imageUrl;
  final String calories;
  final String time;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
    super.initState();
    sl.get<AnalyticsService>().logRecipeViewed(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title;
    final imageUrl = widget.imageUrl;
    final calories = widget.calories;
    final time = widget.time;
    final l10n = context.watch<LocaleProvider>();
    final primaryColor = context.watch<ThemeProvider>().primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(background: Image.network(imageUrl, fit: BoxFit.cover)),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite_border, color: Colors.red),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(title, style: AppTextStyles.heading3)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          l10n.translate('easy'),
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoTile(Icons.access_time_outlined, time, isDark),
                      const SizedBox(width: 16),
                      _buildInfoTile(Icons.bolt_outlined, calories, isDark),
                      const SizedBox(width: 16),
                      _buildInfoTile(Icons.person_outline, '2 serv', isDark),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(l10n.translate('ingredients'), style: AppTextStyles.heading4),
                  const SizedBox(height: 16),
                  _buildIngredientItem('2 aguacates maduros'),
                  _buildIngredientItem('2 huevos orgánicos'),
                  _buildIngredientItem('2 rebanadas de pan integral'),
                  _buildIngredientItem('Sal marina y pimienta negra'),
                  _buildIngredientItem('Semillas de sésamo'),
                  const SizedBox(height: 32),
                  Text(l10n.translate('preparation'), style: AppTextStyles.heading4),
                  const SizedBox(height: 16),
                  _buildPreparationStep(1, 'Tostar el pan integral hasta que esté crujiente.'),
                  _buildPreparationStep(2, 'Machacar el aguacate en un bol con sal y pimienta.'),
                  _buildPreparationStep(3, 'Cocinar los huevos (escalfados o revueltos).'),
                  _buildPreparationStep(4, 'Untar el aguacate sobre el pan y colocar el huevo encima.'),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildIngredientItem(String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.success, size: 20),
          const SizedBox(width: 12),
          Text(name, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildPreparationStep(int step, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.primary,
            child: Text(
              '$step',
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}
