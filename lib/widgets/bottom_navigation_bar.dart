import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

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
    final l10n = AppLocalizations.of(context)!;

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
                context,
                icon: Icons.home,
                label: l10n.home,
                index: 0,
                isSelected: selectedIndex == 0,
              ),
              _buildNavItem(
                context,
                icon: Icons.calendar_today,
                label: l10n.plans,
                index: 1,
                isSelected: selectedIndex == 1,
              ),
              _buildNavItem(
                context,
                icon: Icons.directions_run,
                label: l10n.routines,
                index: 2,
                isSelected: selectedIndex == 2,
              ),
              _buildNavItem(
                context,
                icon: Icons.trending_up,
                label: l10n.progress,
                index: 3,
                isSelected: selectedIndex == 3,
              ),
              _buildNavItem(
                context,
                icon: Icons.group,
                label: l10n.community,
                index: 4,
                isSelected: selectedIndex == 4,
              ),
              _buildNavItem(
                context,
                icon: Icons.person,
                label: l10n.profile,
                index: 5,
                isSelected: selectedIndex == 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
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
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : const Color(0xFF9CA3AF),
              ),
              const SizedBox(height: 2),
              FittedBox(
                child: Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
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
