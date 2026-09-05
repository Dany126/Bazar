import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AdminDashboardHeader extends StatelessWidget {
  const AdminDashboardHeader({super.key, required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard Overview',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.kTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
