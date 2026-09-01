import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_panel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AdminDashboardSalesOverview extends StatelessWidget {
  const AdminDashboardSalesOverview({super.key, required this.bars});

  final List<int> bars;

  @override
  Widget build(BuildContext context) {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final values = bars.isEmpty ? [24, 34, 26, 44, 42, 58, 52] : bars;
    final maxVal = values.isEmpty
        ? 1
        : values.reduce((curr, next) => curr > next ? curr : next);
    final safeMax = (maxVal > 0 ? maxVal : 1).toDouble();

    final spots = List.generate(
      values.length,
      (index) => FlSpot(index.toDouble(), values[index].toDouble()),
    );

    return AdminDashboardPanel(
      title: 'Revenue Over Time',
      trailing: 'This month',
      child: SizedBox(
        height: 220,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, right: 16.0),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: safeMax / 4,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withValues(alpha: 0.15),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: safeMax / 4,
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      if (value == meta.max || value == meta.min) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          value.toInt().toString(),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.kSecondaryTextColor),
                          textAlign: TextAlign.right,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < labels.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            labels[index],
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.kSecondaryTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (values.length - 1).toDouble(),
              minY: 0,
              maxY: safeMax * 1.1,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: AppColors.kPrimaryColor,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.kPrimaryColor.withValues(alpha: 0.3),
                        AppColors.kPrimaryColor.withValues(alpha: 0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
