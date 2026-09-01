import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AdminDashboardHeader extends StatelessWidget {
  const AdminDashboardHeader({super.key, required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.kTextColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Overview of your online store',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.kSecondaryTextColor,
                ),
              ),
            ],
          ),
        ),
        if (isWide)
          const Row(
            children: [
              _HeaderAction(label: 'Export', icon: Icons.download_rounded),
              SizedBox(width: 12),
              _HeaderAction(
                label: 'Add product',
                icon: Icons.add_rounded,
                filled: true,
              ),
            ],
          ),
      ],
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.label,
    required this.icon,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final isFilled = filled;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isFilled ? AppColors.kPrimaryColor : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isFilled ? Colors.white : AppColors.kTextColor,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isFilled ? Colors.white : AppColors.kTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
