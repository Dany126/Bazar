import 'package:e_commerce/core/helper_function/shared_prefs_helper.dart';
import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_dashboard_state.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_categories.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_header.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_inventory.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_recent_orders.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_sales_overview.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  static const routeName = 'admin_dashboard';

  @override
  Widget build(BuildContext context) {
    // Check role stored after authentication.
    final isAdmin = SharedPrefsHelper.isAdmin();

    // Prevent normal users from opening the dashboard.
    if (!isAdmin) {
      return const Scaffold(
        body: Center(child: Text('Access denied. Admin only.')),
      );
    }

    return BlocProvider<AdminDashboardCubit>(
      create: (_) {
        return getIt<AdminDashboardCubit>()..loadDashboard();
      },
      child: const _AdminDashboardBody(),
    );
  }
}

class _AdminDashboardBody extends StatelessWidget {
  const _AdminDashboardBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
          builder: (context, state) {
            // =========================
            // LOADING
            // =========================

            if (state is AdminDashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // =========================
            // FAILURE
            // =========================

            if (state is AdminDashboardFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Unable to load dashboard data:\n${state.message}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            // =========================
            // DATA
            // =========================

            final data = state is AdminDashboardLoaded
                ? state.data
                : AdminDashboardData.empty();

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 1100;
                final isMedium = constraints.maxWidth >= 760;

                return SingleChildScrollView(
                  padding: EdgeInsets.all(isWide ? 28 : 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =========================
                      // HEADER
                      // =========================
                      AdminDashboardHeader(isWide: isWide),

                      const SizedBox(height: 24),

                      // =========================
                      // STATS
                      // =========================
                      AdminDashboardStats.fromData(data: data),

                      const SizedBox(height: 24),

                      // =========================
                      // SALES + CATEGORIES
                      // =========================
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: AdminDashboardSalesOverview(
                                bars: data.salesTrend,
                              ),
                            ),

                            const SizedBox(width: 20),

                            Expanded(
                              child: AdminDashboardCategories(
                                categories: data.categoryBreakdown,
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            AdminDashboardSalesOverview(bars: data.salesTrend),

                            const SizedBox(height: 20),

                            AdminDashboardCategories(
                              categories: data.categoryBreakdown,
                            ),
                          ],
                        ),

                      const SizedBox(height: 24),

                      // =========================
                      // ORDERS + INVENTORY
                      // =========================
                      if (isMedium)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: AdminDashboardRecentOrders(
                                orders: data.recentOrders,
                              ),
                            ),

                            const SizedBox(width: 20),

                            Expanded(
                              child: AdminDashboardInventory(
                                items: data.lowInventory,
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            AdminDashboardRecentOrders(
                              orders: data.recentOrders,
                            ),

                            const SizedBox(height: 20),

                            AdminDashboardInventory(items: data.lowInventory),
                          ],
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
