import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_panel.dart';
import 'package:flutter/material.dart';

class AdminDashboardInventory extends StatelessWidget {
  const AdminDashboardInventory({super.key, required this.items});

  final List<AdminInventoryItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const AdminDashboardPanel(
        title: 'Low Inventory',
        child: SizedBox(height: 160, child: Center(child: Text('No data'))),
      );
    }

    return AdminDashboardPanel(
      title: 'Low Inventory',
      trailing: '${items.length} variants',
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _InventoryRow(item: items[i]),

            if (i != items.length - 1) const Divider(height: 24),
          ],
        ],
      ),
    );
  }
}

class _InventoryRow extends StatelessWidget {
  const _InventoryRow({required this.item});

  final AdminInventoryItem item;

  @override
  Widget build(BuildContext context) {
    final critical = item.count <= 0;

    final variantParts = [
      if (item.size != null && item.size!.isNotEmpty) item.size!,
      if (item.color != null && item.color!.isNotEmpty) item.color!,
    ];

    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade100,
          ),
          child: const Icon(Icons.inventory_2_outlined),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),

              if (variantParts.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    variantParts.join(' • '),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: critical
                ? Colors.red.withOpacity(.10)
                : Colors.orange.withOpacity(.10),
          ),
          child: Text(
            '${item.count} left',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: critical ? Colors.red : Colors.orange.shade800,
            ),
          ),
        ),
      ],
    );
  }
}
