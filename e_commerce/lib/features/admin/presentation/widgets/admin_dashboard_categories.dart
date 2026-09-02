import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_panel.dart';
import 'package:flutter/material.dart';

class AdminDashboardCategories extends StatelessWidget {
  const AdminDashboardCategories({super.key, required this.categories});
  final List<AdminCategoryBreakdown> categories;
  @override
  Widget build(BuildContext context) {
    return AdminDashboardPanel(
      title: 'Top categories',
      child: categories.isEmpty
          ? const SizedBox(height: 120, child: Center(child: Text('No data')))
          : Column(
              children: categories
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(entry.name)),
                              Text('${entry.percent.toStringAsFixed(0)}%'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: (entry.percent / 100).clamp(0, 1),
                              minHeight: 8,
                              backgroundColor: const Color(0xFFF0F0F5),
                              valueColor: const AlwaysStoppedAnimation(
                                AppColors.kPrimaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
