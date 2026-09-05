import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_panel.dart';
import 'package:flutter/material.dart';

class AdminDashboardCategories extends StatelessWidget {
  const AdminDashboardCategories({super.key, required this.categories});

  final List<AdminCategoryBreakdown> categories;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const AdminDashboardPanel(
        title: 'Top Categories',
        child: SizedBox(height: 220, child: Center(child: Text('No data'))),
      );
    }

    return AdminDashboardPanel(
      title: 'Top Categories',
      child: Column(
        children: [
          for (int i = 0; i < categories.length; i++) ...[
            _CategoryRow(category: categories[i]),

            if (i != categories.length - 1) const SizedBox(height: 18),
          ],
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category});

  final AdminCategoryBreakdown category;

  @override
  Widget build(BuildContext context) {
    final percent = category.percent.clamp(0.0, 100.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

            Text(
              '${percent.toStringAsFixed(1)}%',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),

        const SizedBox(height: 7),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(value: percent / 100, minHeight: 7),
        ),

        const SizedBox(height: 6),

        Text(
          '${category.count} items',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
