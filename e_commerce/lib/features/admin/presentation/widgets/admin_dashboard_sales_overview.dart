import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_panel.dart';
import 'package:flutter/material.dart';

class AdminDashboardSalesOverview extends StatelessWidget {
  const AdminDashboardSalesOverview({super.key, required this.bars});

  final List<int> bars;

  @override
  Widget build(BuildContext context) {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final values = bars.isEmpty ? [24, 34, 26, 44, 42, 58, 52] : bars;

    return AdminDashboardPanel(
      title: 'Sales overview',
      trailing: 'This month',
      child: SizedBox(
        height: 250,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(values.length, (index) {
            final value = values[index].toDouble();
            final isAccent = index == 5 || index == 6;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 24,
                      height: value.clamp(18, 100).toDouble() * 2.4,
                      decoration: BoxDecoration(
                        color: isAccent
                            ? AppColors.kPrimaryColor
                            : const Color(0xFFE7E1FF),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      labels[index],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.kSecondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
