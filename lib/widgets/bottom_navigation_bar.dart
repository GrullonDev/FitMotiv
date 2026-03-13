import 'package:flutter/material.dart';
import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });
  final int selectedIndex;
  final Function(int) onItemSelected;

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildNavItem(
                icon: Icons.home,
                label: localeProvider.translate('home'),
                index: 0,
                isSelected: selectedIndex == 0,
              ),
              _buildNavItem(
                icon: Icons.calendar_today,
                label: localeProvider.translate('plans'),
                index: 1,
                isSelected: selectedIndex == 1,
              ),
              _buildNavItem(
                icon: Icons.directions_run,
                label: localeProvider.translate('routines'),
                index: 2,
                isSelected: selectedIndex == 2,
              ),
              _buildNavItem(
                icon: Icons.trending_up,
                label: localeProvider.translate('progress'),
                index: 3,
                isSelected: selectedIndex == 3,
              ),
              _buildNavItem(
                icon: Icons.group,
                label: localeProvider.translate('community'),
                index: 4,
                isSelected: selectedIndex == 4,
              ),
              _buildNavItem(
                icon: Icons.person,
                label: localeProvider.translate('profile'),
                index: 5,
                isSelected: selectedIndex == 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onItemSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? AppColors.primary : const Color(0xFF9CA3AF),
              ),
              const SizedBox(height: 2),
              FittedBox(
                child: Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
