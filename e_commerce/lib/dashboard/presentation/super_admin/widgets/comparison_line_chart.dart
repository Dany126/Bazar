import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/section_card.dart';

class ComparisonLineChart extends StatelessWidget {
  const ComparisonLineChart({
    super.key,
    required this.title,
    required this.seriesA,
    required this.seriesB,
    required this.seriesALabel,
    required this.seriesBLabel,
  });

  final String title;
  final List<double> seriesA;
  final List<double> seriesB;
  final String seriesALabel;
  final String seriesBLabel;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      background: DashboardColors.cardBgDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
              Row(
                children: [
                  _legendDot(DashboardColors.accent, seriesALabel),
                  const SizedBox(width: 14),
                  _legendDot(DashboardColors.textSecondaryDark, seriesBLabel),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 240,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(color: DashboardColors.divider, strokeWidth: 1),
                ),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [for (var i = 0; i < seriesA.length; i++) FlSpot(i.toDouble(), seriesA[i])],
                    isCurved: true,
                    color: DashboardColors.accent,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: [for (var i = 0; i < seriesB.length; i++) FlSpot(i.toDouble(), seriesB[i])],
                    isCurved: true,
                    color: DashboardColors.textSecondaryDark,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11.5)),
      ],
    );
  }
}
