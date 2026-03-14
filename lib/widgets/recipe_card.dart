import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key});

  @override
  Widget build(BuildContext context) {
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
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              color: const Color(0xFFF3F4F6),
            ),
            child: Stack(
              children: [
                // Simulación de imagen de aguacate
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(color: const Color(0xFF86EFAC), borderRadius: BorderRadius.circular(60)),
                    child: Stack(
                      children: [
                        // Aguacate base
                        Positioned(
                          left: 20,
                          top: 20,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E),
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                        // Semilla del aguacate
                        Positioned(
                          left: 45,
                          top: 45,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDE68A),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        // Pan tostado (base)
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Container(
                            height: 15,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD2B48C),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Información de la receta
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Avocado Toast with Egg', style: AppTextStyles.heading3),
                const SizedBox(height: 8),
                Text(
                  'A nutritious and delicious breakfast option to start your day right.',
                  style: AppTextStyles.bodyMedium.copyWith(height: 1.4),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoChip(icon: Icons.access_time, text: '10 min', color: const Color(0xFF00D4A3)),
                    const SizedBox(width: 12),
                    _buildInfoChip(icon: Icons.local_fire_department, text: '320 cal', color: const Color(0xFFFF6B6B)),
                    const SizedBox(width: 12),
                    _buildInfoChip(icon: Icons.star, text: '4.8', color: const Color(0xFFFFA726)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // Acción para ver la receta
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
