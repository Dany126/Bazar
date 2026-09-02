import 'package:e_commerce/features/admin/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminOverviewView extends StatelessWidget {
  const AdminOverviewView({super.key});
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
        builder: (context, state) {
          if (state is AdminDashboardLoading ||
              state is AdminDashboardInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AdminDashboardFailure) {
            return Center(child: Text(state.message));
          }
          final d = (state as AdminDashboardLoaded).data;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overview',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _Metric('Products', d.totalProducts.toString()),
                    _Metric('Categories', d.totalCategories.toString()),
                    _Metric('Customers', d.totalUsers.toString()),
                    _Metric(
                      'Period revenue',
                      '\$${d.periodRevenue.toStringAsFixed(2)}',
                    ),
                    _Metric('Period orders', d.periodOrders.toString()),
                    _Metric('Low stock', d.lowStockAlerts.toString()),
                  ],
                ),
              ],
            ),
          );
        },
      );
}

class _Metric extends StatelessWidget {
  final String label, value;
  const _Metric(this.label, this.value);
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 220,
    child: Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    ),
  );
}
