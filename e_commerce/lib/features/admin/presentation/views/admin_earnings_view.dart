import 'package:e_commerce/features/admin/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_dashboard_state.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_sales_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminEarningsView extends StatelessWidget {
  const AdminEarningsView({super.key});
  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
    builder: (context, state) {
      if (state is AdminDashboardLoading || state is AdminDashboardInitial)
        return const Center(child: CircularProgressIndicator());
      if (state is AdminDashboardFailure)
        return Center(child: Text(state.message));
      final d = (state as AdminDashboardLoaded).data;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Earnings',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            Text('Total revenue: \$${d.totalRevenue.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text(
              'Revenue for ${d.period}: \$${d.periodRevenue.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 24),
            AdminDashboardSalesOverview(
              points: d.revenueChart,
              period: d.period,
            ),
          ],
        ),
      );
    },
  );
}
