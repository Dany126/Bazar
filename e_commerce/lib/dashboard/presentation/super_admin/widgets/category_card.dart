import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.icon,
    required this.name,
    required this.productCount,
    this.onEdit,
    this.onDelete,
  });

  final IconData icon;
  final String name;
  final int productCount;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: DashboardColors.cardBgDarkAlt, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: DashboardColors.accentSoft, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 17, color: DashboardColors.accent),
              ),
              Icon(Icons.drag_indicator_rounded, size: 18, color: DashboardColors.textSecondaryDark.withOpacity(0.6)),
            ],
          ),
          const SizedBox(height: 14),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('$productCount Products', style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11.5)),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: onEdit,
                child: const Icon(Icons.edit_outlined, size: 16, color: DashboardColors.textSecondaryDark),
              ),
              const SizedBox(width: 14),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.delete_outline_rounded, size: 16, color: DashboardColors.danger),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
