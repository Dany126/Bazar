import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_stat_card.dart';
import 'package:flutter/material.dart';

class AdminDashboardStats extends StatelessWidget {
  const AdminDashboardStats({super.key, required this.data});

  final AdminDashboardData data;

  String money(double value) {
    return '${value.toStringAsFixed(2)} ${data.store.currency}';
  }

  String percentageChange(double? value) {
    if (value == null) {
      return 'No data';
    }

    final prefix = value > 0 ? '+' : '';

    return '$prefix${value.toStringAsFixed(1)}%';
  }

  String conversion(double? value) {
    if (value == null) {
      return 'No data';
    }

    return '${value.toStringAsFixed(2)}%';
  }

  @override
  Widget build(BuildContext context) {
    final stats = [
      _MetricStat(
        label: 'Revenue',
        value: money(data.periodRevenue),
        change: percentageChange(data.changes.revenue),
        color: const Color(0xFF8E6CEF),
        isPrimary: true,
      ),
      _MetricStat(
        label: 'Orders',
        value: data.periodOrders.toString(),
        change: percentageChange(data.changes.orders),
        color: const Color(0xFF4EC5A5),
      ),
      _MetricStat(
        label: 'Visitors',
        value: data.totalVisitors.toString(),
        change: percentageChange(data.changes.visitors),
        color: const Color(0xFF1F2937),
      ),
      _MetricStat(
        label: 'Conversion rate',
        value: conversion(data.conversionRate),
        change: percentageChange(data.changes.conversionRate),
        color: const Color(0xFFDC2626),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final crossAxisCount = width >= 1100
            ? 4
            : width >= 600
            ? 2
            : 1;

        final aspectRatio = width >= 1100
            ? 1.65
            : width >= 600
            ? 1.8
            : 2.5;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stats.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (context, index) {
            final stat = stats[index];

            return AdminDashboardStatCard(
              label: stat.label,
              value: stat.value,
              change: stat.change,
              color: stat.color,
              isPrimary: stat.isPrimary,
              comparisonLabel: 'vs previous ${data.period}',
            );
          },
        );
      },
    );
  }
}

class _MetricStat {
  const _MetricStat({
    required this.label,
    required this.value,
    required this.change,
    required this.color,
    this.isPrimary = false,
  });

  final String label;
  final String value;
  final String change;
  final Color color;
  final bool isPrimary;
}
