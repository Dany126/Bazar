import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_stat_card.dart';
import 'package:flutter/material.dart';

class AdminDashboardStats extends StatelessWidget {
  const AdminDashboardStats({super.key, required this.data});

  factory AdminDashboardStats.fromData({required AdminDashboardData data}) {
    return AdminDashboardStats(data: data);
  }

  final AdminDashboardData data;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _MetricStat(
        label: 'Total revenue',
        value: '\$ ${data.totalRevenue.toStringAsFixed(0)}',
        change: '+12.5%',
        color: const Color(0xFF8E6CEF),
      ),
      _MetricStat(
        label: 'Orders',
        value: data.totalOrders.toString(),
        change: '+8.2%',
        color: const Color(0xFF4EC5A5),
      ),
      _MetricStat(
        label: 'Active Products',
        value: data.totalProducts.toString(),
        change: '0.0%',
        color: const Color(0xFF1F2937),
      ),
      _MetricStat(
        label: 'Low Stock Alerts',
        value: data.lowInventory.length.toString(),
        change: '+3 items',
        color: const Color(0xFFDC2626),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1200;
        final isMedium = constraints.maxWidth >= 768;

        int crossAxisCount = 1;
        if (isWide) {
          crossAxisCount = 4;
        } else if (isMedium) {
          crossAxisCount = 2;
        }

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: stats
              .map(
                (stat) => AdminDashboardStatCard(
                  label: stat.label,
                  value: stat.value,
                  change: stat.change,
                  color: stat.color,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _MetricStat {
  const _MetricStat({
    required this.label,
    required this.value,
    required this.change,
    required this.color,
  });

  final String label;
  final String value;
  final String change;
  final Color color;
}
