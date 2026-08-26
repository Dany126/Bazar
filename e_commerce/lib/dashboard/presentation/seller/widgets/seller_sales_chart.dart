import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/section_card.dart';

/// "Sales Performance" bar chart shown on the Seller Overview screen.
class SellerSalesChart extends StatelessWidget {
  const SellerSalesChart({super.key, required this.values});

  /// One bar height per day (e.g. last 7 days of sales).
  final List<double> values;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      background: DashboardColors.cardBgLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sales Performance',
            style: TextStyle(
              color: DashboardColors.textPrimaryLight,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: DashboardColors.contentBgDark,
                borderRadius: BorderRadius.circular(14),
              ),
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  barTouchData: BarTouchData(enabled: false),
                  barGroups: [
                    for (var i = 0; i < values.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: values[i],
                            color: DashboardColors.accent,
                            width: 22,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
