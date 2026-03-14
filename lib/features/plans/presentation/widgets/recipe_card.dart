import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/core/theme/theme_provider.dart';
import 'package:fit_motiv/features/plans/presentation/screens/recipe_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
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
    final primaryColor = context.watch<ThemeProvider>().primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      clipBehavior: Clip.antiAlias,
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RecipeDetailScreen(title: title, imageUrl: imageUrl, calories: calories, time: time),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // Image with smooth Fade-in
                    Image.network(
                      imageUrl,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) return child;
                        return AnimatedOpacity(
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                          child: child,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.restaurant_outlined,
                              color: primaryColor.withValues(alpha: 0.2),
                              size: 32,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200],
                        alignment: Alignment.center,
                        child: Icon(Icons.receipt_long_outlined, color: primaryColor.withValues(alpha: 0.3), size: 32),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              time,
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.bolt, size: 14, color: primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          calories,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
