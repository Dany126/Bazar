import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_panel.dart';
import 'package:flutter/material.dart';

class AdminDashboardInventory extends StatelessWidget {
  const AdminDashboardInventory({super.key, required this.items});

  final List<AdminInventoryItem> items;

  @override
  Widget build(BuildContext context) {
    final list = items.isEmpty
        ? const [AdminInventoryItem(name: 'No low-stock products', count: 0)]
        : items;

    return AdminDashboardPanel(
      title: 'Low inventory',
      child: Column(
        children: list.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Text(
                  item.count == 0 ? 'No stock' : '${item.count} left',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: const Color(0xFFEC8B18),
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
