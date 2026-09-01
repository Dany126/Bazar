import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_panel.dart';
import 'package:flutter/material.dart';

class AdminDashboardCategories extends StatelessWidget {
  const AdminDashboardCategories({super.key, required this.categories});

  final List<AdminCategoryBreakdown> categories;

  @override
  Widget build(BuildContext context) {
    final items = categories.isEmpty
        ? const [AdminCategoryBreakdown(name: 'General', percent: 100)]
        : categories;

    return AdminDashboardPanel(
      title: 'Top categories',
      child: Column(
        children: items.map((entry) {
          final percent = entry.percent.clamp(0.0, 100.0);

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.name,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Text(
                      '${percent.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.kSecondaryTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: percent / 100,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFF0F0F5),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.kPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
