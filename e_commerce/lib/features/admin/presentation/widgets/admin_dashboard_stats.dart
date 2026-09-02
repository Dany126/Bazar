import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_stat_card.dart';
import 'package:flutter/material.dart';

class AdminDashboardStats extends StatelessWidget {
  const AdminDashboardStats({super.key, required this.data});
  factory AdminDashboardStats.fromData({required AdminDashboardData data}) => AdminDashboardStats(data: data);
  final AdminDashboardData data;

  String money(double value) => '\$ ${value.toStringAsFixed(2)}';
  String change(double? value) => value == null ? 'No data' : '${value >= 0 ? '+' : ''}${value.toStringAsFixed(1)}%';
  String conversion(double? value) => value == null ? 'No data' : '${value.toStringAsFixed(2)}%';

  @override
  Widget build(BuildContext context) {
    final stats = [
      _MetricStat('Total revenue', money(data.totalRevenue), change(data.changes.revenue), const Color(0xFF8E6CEF)),
      _MetricStat('Orders', data.totalOrders.toString(), change(data.changes.orders), const Color(0xFF4EC5A5)),
      _MetricStat('Visitors', data.totalVisitors.toString(), change(data.changes.visitors), const Color(0xFF1F2937)),
      _MetricStat('Conversion rate', conversion(data.conversionRate), change(data.changes.conversionRate), const Color(0xFFDC2626)),
    ];
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final count = width >= 1100 ? 4 : width >= 600 ? 2 : 1;
      return GridView.count(
        crossAxisCount: count,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: width >= 1100 ? 1.45 : width >= 600 ? 1.6 : 2.4,
        children: [for (final s in stats) AdminDashboardStatCard(label: s.label, value: s.value, change: s.change, color: s.color, comparisonLabel: 'vs previous ${data.period}')],
      );
    });
  }
}

class _MetricStat {
  const _MetricStat(this.label, this.value, this.change, this.color);
  final String label;
  final String value;
  final String change;
  final Color color;
}
