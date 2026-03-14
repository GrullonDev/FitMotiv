import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/features/plans/presentation/providers/plans_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Card de "Healthy Recipe" en el Dashboard.
/// Ahora lee los datos desde PlansProvider (Supabase).
class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlansProvider>();
    final recipe = provider.dailyRecipe;

    // Si está cargando
    if (provider.isLoading) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color ?? Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
      );
    }

    // Si no hay receta
    if (recipe == null) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color ?? Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.restaurant_menu,
                size: 48,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 12),
              Text('No hay recetas aún', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 4),
              Text('Agrega recetas a la base de datos', style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      );
    }

    final title = recipe['title'] as String? ?? 'Recipe';
    final description = recipe['description'] as String? ?? 'A nutritious and delicious recipe.';
    final time = recipe['time'] as String? ?? '';
    final calories = recipe['calories'] as String? ?? '';
    final rating = (recipe['rating'] as num?)?.toDouble() ?? 0;
    final imageUrl = recipe['image_url'] as String? ?? '';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Imagen de la receta
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholderImage(context),
                  )
                : _buildPlaceholderImage(context),
          ),
          // Información de la receta
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.heading3),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium.copyWith(height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (time.isNotEmpty)
                      _buildInfoChip(icon: Icons.access_time, text: time, color: const Color(0xFF00D4A3)),
                    if (time.isNotEmpty) const SizedBox(width: 12),
                    if (calories.isNotEmpty)
                      _buildInfoChip(icon: Icons.local_fire_department, text: calories, color: const Color(0xFFFF6B6B)),
                    if (calories.isNotEmpty) const SizedBox(width: 12),
                    if (rating > 0)
                      _buildInfoChip(icon: Icons.star, text: rating.toStringAsFixed(1), color: const Color(0xFFFFA726)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/plans');
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'View Recipe',
                      style: AppTextStyles.buttonText.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      color: const Color(0xFFF3F4F6),
      child: Center(
        child: Icon(Icons.restaurant, size: 60, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(text, style: AppTextStyles.chipText.copyWith(color: color)),
        ],
      ),
    );
  }
}
