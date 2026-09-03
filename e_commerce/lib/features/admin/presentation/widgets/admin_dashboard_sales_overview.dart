import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_panel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AdminDashboardSalesOverview extends StatelessWidget {
  const AdminDashboardSalesOverview({
    super.key,
    required this.points,
    required this.period,
  });

  final List<AdminRevenuePoint> points;
  final String period;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const AdminDashboardPanel(
        title: 'Revenue Over Time',
        child: SizedBox(height: 220, child: Center(child: Text('No data'))),
      );
    }

    final maxRevenue = points
        .map((e) => e.revenue)
        .reduce((a, b) => a > b ? a : b);

    final safeMax = maxRevenue > 0 ? maxRevenue : 1.0;

    final spots = List.generate(
      points.length,
      (index) => FlSpot(index.toDouble(), points[index].revenue),
    );

    final interval = safeMax / 4;

    return AdminDashboardPanel(
      title: 'Revenue Over Time',
      trailing: period,
      child: SizedBox(
        height: 250,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: (points.length - 1).toDouble(),
            minY: 0,
            maxY: safeMax * 1.15,

            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: interval > 0 ? interval : 1,
            ),

            borderData: FlBorderData(show: false),

            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 55,
                  interval: interval > 0 ? interval : 1,
                ),
              ),

              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: points.length > 8
                      ? (points.length / 6).ceilToDouble()
                      : 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.round();

                    if (index < 0 || index >= points.length) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        points[index].label,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.kSecondaryTextColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: AppColors.kPrimaryColor,
                barWidth: 3,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
