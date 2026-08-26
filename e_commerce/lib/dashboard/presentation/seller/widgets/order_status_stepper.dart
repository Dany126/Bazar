import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';

class OrderStatusStepper extends StatelessWidget {
  const OrderStatusStepper({super.key, required this.steps, required this.currentIndex});

  final List<String> steps;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: i <= currentIndex ? DashboardColors.accent : DashboardColors.cardBgDarkAlt,
                  shape: BoxShape.circle,
                  border: i == currentIndex ? Border.all(color: Colors.white, width: 2) : null,
                ),
                child: Icon(
                  i < currentIndex ? Icons.check_rounded : Icons.circle,
                  size: i < currentIndex ? 14 : 8,
                  color: i <= currentIndex ? Colors.white : DashboardColors.textSecondaryDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(steps[i], style: TextStyle(color: i <= currentIndex ? Colors.white : DashboardColors.textSecondaryDark, fontSize: 11)),
            ],
          ),
          if (i != steps.length - 1)
            Expanded(
              child: Container(height: 2, margin: const EdgeInsets.only(bottom: 20), color: i < currentIndex ? DashboardColors.accent : DashboardColors.divider),
            ),
        ],
      ],
    );
  }
}
