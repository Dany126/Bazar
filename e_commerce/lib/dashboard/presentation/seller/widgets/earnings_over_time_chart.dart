import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/section_card.dart';

class EarningsOverTimeChart extends StatelessWidget {
  const EarningsOverTimeChart({super.key, required this.points});

  final List<double> points;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      background: DashboardColors.cardBgDarkAlt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Earnings Over Time', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [for (var i = 0; i < points.length; i++) FlSpot(i.toDouble(), points[i])],
                    isCurved: true,
                    color: DashboardColors.accent,
                    barWidth: 0.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [DashboardColors.accent.withOpacity(0.9), DashboardColors.accent.withOpacity(0.5)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
