import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';
import 'package:fit_motiv/core/theme/theme_provider.dart';
import 'package:fit_motiv/features/plans/presentation/screens/plan_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NutritionPlanCard extends StatelessWidget {
  const NutritionPlanCard({
    super.key,
    required this.title,
    required this.description,
    required this.calories,
    required this.icon,
    required this.badgeText,
    this.isRecommended = false,
  });

  final String title;
  final String description;
  final String calories;
  final IconData icon;
  final String badgeText;
  final bool isRecommended;

  @override
  Widget build(BuildContext context) {
    final l10n = context.read<LocaleProvider>();
    final primaryColor = context.watch<ThemeProvider>().primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PlanDetailScreen(title: title)));
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: primaryColor.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: primaryColor, size: 28),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isRecommended ? primaryColor : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: isRecommended ? null : Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        isRecommended ? l10n.translate('recommended') : badgeText,
                        style: TextStyle(
                          color: isRecommended ? Colors.white : AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(title, style: AppTextStyles.heading4.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(description, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.bolt, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      calories,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600, // Task 2: More bold
                      ),
                    ),
                    if (!isRecommended) ...[
                      const SizedBox(width: 16),
                      const Icon(Icons.timer_outlined, size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(badgeText, style: AppTextStyles.bodySmall),
                    ],
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PlanDetailScreen(title: title)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRecommended ? primaryColor : Colors.transparent,
                      foregroundColor: isRecommended ? Colors.white : primaryColor,
                      elevation: isRecommended ? 4 : 0,
                      side: isRecommended ? null : BorderSide(color: primaryColor, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      l10n.translate('view_plan'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
