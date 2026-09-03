import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_stat_card.dart';
import 'package:flutter/material.dart';

class AdminDashboardStats extends StatelessWidget {
  const AdminDashboardStats({super.key, required this.data});

  final AdminDashboardData data;

  String _money(double value) {
    return '${value.toStringAsFixed(2)} ${data.store.currency}';
  }

  String _change(double? value) {
    if (value == null) {
      return 'No data';
    }

    final prefix = value > 0 ? '+' : '';

    return '$prefix${value.toStringAsFixed(1)}%';
  }

  String _conversion(double? value) {
    if (value == null) {
      return 'No data';
    }

    return '${value.toStringAsFixed(2)}%';
  }

  @override
  Widget build(BuildContext context) {
    final stats = [
      // ----------------------------------------------------------
      // PRIMARY CARDS
      // ----------------------------------------------------------
      _Metric(
        label: 'Revenue',
        value: _money(data.periodRevenue),
        change: _change(data.changes.revenue),
        color: const Color(0xFF8E6CEF),
        primary: true,
      ),

      _Metric(
        label: 'Orders',
        value: data.periodOrders.toString(),
        change: _change(data.changes.orders),
        color: const Color(0xFF4EC5A5),
      ),

      _Metric(
        label: 'Visitors',
        value: data.totalVisitors.toString(),
        change: _change(data.changes.visitors),
        color: const Color(0xFF1F2937),
      ),

      _Metric(
        label: 'Conversion rate',
        value: _conversion(data.conversionRate),
        change: _change(data.changes.conversionRate),
        color: const Color(0xFFDC2626),
      ),

      // ----------------------------------------------------------
      // SECONDARY CARDS
      // ----------------------------------------------------------
      _Metric(
        label: 'Products',
        value: data.totalProducts.toString(),
        change: 'No data',
        color: const Color(0xFF2563EB),
      ),

      _Metric(
        label: 'Categories',
        value: data.totalCategories.toString(),
        change: 'No data',
        color: const Color(0xFF7C3AED),
      ),

      _Metric(
        label: 'Customers',
        value: data.totalUsers.toString(),
        change: 'No data',
        color: const Color(0xFF0891B2),
      ),

      _Metric(
        label: 'Low Inventory',
        value: data.lowStockAlerts.toString(),
        change: 'No data',
        color: const Color(0xFFEA580C),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final columns = width >= 1100
            ? 4
            : width >= 600
            ? 2
            : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stats.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: width >= 1100
                ? 1.65
                : width >= 600
                ? 1.8
                : 2.5,
          ),
          itemBuilder: (context, index) {
            final stat = stats[index];

            return AdminDashboardStatCard(
              label: stat.label,
              value: stat.value,
              change: stat.change,
              color: stat.color,
              isPrimary: stat.primary,
              comparisonLabel: 'vs previous ${data.period}',
            );
          },
        );
      },
    );
  }
}

class _Metric {
  const _Metric({
    required this.label,
    required this.value,
    required this.change,
    required this.color,
    this.primary = false,
  });

  final String label;
  final String value;
  final String change;
  final Color color;
  final bool primary;
}
