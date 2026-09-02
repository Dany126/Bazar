import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_panel.dart';
import 'package:flutter/material.dart';

class AdminDashboardInventory extends StatelessWidget {
  const AdminDashboardInventory({super.key, required this.items});
  final List<AdminInventoryItem> items;
  @override
  Widget build(BuildContext context) {
    return AdminDashboardPanel(
      title: 'Low inventory',
      child: items.isEmpty
          ? const SizedBox(height: 120, child: Center(child: Text('No data')))
          : Column(children: items.map((item) {
              final details = [if (item.size?.isNotEmpty == true) item.size!, if (item.color?.isNotEmpty == true) item.color!].join(' • ');
              return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF7F7FA), borderRadius: BorderRadius.circular(12)), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.name), if (details.isNotEmpty) Text(details, style: const TextStyle(fontSize: 12))])), Text('${item.count} left') ]));
            }).toList()),
    );
  }
}
