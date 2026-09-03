import 'package:e_commerce/core/helper_function/shared_prefs_helper.dart';
import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_dashboard_state.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_navigation_cubit.dart';
import 'package:e_commerce/features/admin/presentation/views/admin_categories_view.dart';
import 'package:e_commerce/features/admin/presentation/views/admin_customers_view.dart';
import 'package:e_commerce/features/admin/presentation/views/admin_earnings_view.dart';
import 'package:e_commerce/features/admin/presentation/views/admin_orders_view.dart';
import 'package:e_commerce/features/admin/presentation/views/admin_payouts_view.dart';
import 'package:e_commerce/features/admin/presentation/views/admin_products_view.dart';
import 'package:e_commerce/features/admin/presentation/views/admin_settings_view.dart';
import 'package:e_commerce/features/admin/presentation/views/admin_workspace_view.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_categories.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_header.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_inventory.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_recent_orders.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_sales_overview.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_stats.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  static const routeName = 'admin_dashboard';

  @override
  Widget build(BuildContext context) {
    if (!SharedPrefsHelper.isAdmin()) {
      return const Scaffold(
        body: Center(child: Text('Access denied. Admin only.')),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<AdminDashboardCubit>(
          create: (_) => getIt<AdminDashboardCubit>()..loadDashboard(),
        ),
        BlocProvider<AdminNavigationCubit>(
          create: (_) => AdminNavigationCubit(),
        ),
      ],
      child: const _AdminDashboardBody(),
    );
  }
}

class _AdminDashboardBody extends StatelessWidget {
  const _AdminDashboardBody();

  Widget _content(BuildContext context, int index, bool wide, bool medium) {
    switch (index) {
      case 0:
        return _dashboard(context, wide, medium);

      case 1:
        return const AdminCustomersView();

      case 2:
        return const AdminProductsView();

      case 3:
        return const AdminCategoriesView();

      case 4:
        return const AdminOrdersView();

      case 5:
        return const AdminWorkspaceView();

      case 6:
        return const AdminSettingsView();

      case 7:
        return const AdminEarningsView();

      case 8:
        return const AdminPayoutsView();

      default:
        return const Center(child: Text('No data'));
    }
  }

  Widget _dashboard(BuildContext context, bool wide, bool medium) {
    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, state) {
        if (state is AdminDashboardInitial || state is AdminDashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AdminDashboardFailure) {
          return _DashboardError(
            message: state.message,
            onRetry: () {
              context.read<AdminDashboardCubit>().loadDashboard();
            },
          );
        }

        if (state is! AdminDashboardLoaded) {
          return const Center(child: Text('No data'));
        }

        final data = state.data;

        return RefreshIndicator(
          onRefresh: () {
            return context.read<AdminDashboardCubit>().loadDashboard(
              period: data.period,
            );
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(wide ? 28 : 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdminDashboardHeader(isWide: wide),

                const SizedBox(height: 18),

                _DashboardPeriodSelector(
                  period: data.period,
                  onChanged: (period) {
                    context.read<AdminDashboardCubit>().loadDashboard(
                      period: period,
                    );
                  },
                ),

                const SizedBox(height: 20),

                AdminDashboardStats(data: data),

                const SizedBox(height: 24),

                if (wide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: AdminDashboardSalesOverview(
                          points: data.revenueChart,
                          period: data.period,
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
                      AdminDashboardSalesOverview(
                        points: data.revenueChart,
                        period: data.period,
                      ),
                      const SizedBox(height: 20),
                      AdminDashboardCategories(
                        categories: data.categoryBreakdown,
                      ),
                    ],
                  ),

                const SizedBox(height: 24),

                if (medium)
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
                      AdminDashboardRecentOrders(orders: data.recentOrders),
                      const SizedBox(height: 20),
                      AdminDashboardInventory(items: data.lowInventory),
                    ],
                  ),

                const SizedBox(height: 24),

                _DashboardSummary(
                  totalProducts: data.totalProducts,
                  totalCategories: data.totalCategories,
                  totalUsers: data.totalUsers,
                  lowStockAlerts: data.lowStockAlerts,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 1100;
        final medium = constraints.maxWidth >= 760;
        final sidebarVisible = constraints.maxWidth >= 900;

        return BlocBuilder<AdminNavigationCubit, int>(
          builder: (context, selectedIndex) {
            final sidebar = AdminSidebar(
              selectedIndex: selectedIndex,
              onItemSelected: (index) {
                context.read<AdminNavigationCubit>().updateIndex(index);

                if (!sidebarVisible && Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
            );

            return Scaffold(
              backgroundColor: const Color(0xFFF3F5F9),

              drawer: sidebarVisible ? null : Drawer(child: sidebar),

              body: SafeArea(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (sidebarVisible) sidebar,

                    Expanded(
                      child: _content(context, selectedIndex, wide, medium),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _DashboardPeriodSelector extends StatelessWidget {
  const _DashboardPeriodSelector({
    required this.period,
    required this.onChanged,
  });

  final String period;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_month_rounded, size: 20),
          const SizedBox(width: 10),
          const Text('Period', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 12),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: period,
              isDense: true,
              items: const [
                DropdownMenuItem(value: 'week', child: Text('This week')),
                DropdownMenuItem(value: 'month', child: Text('This month')),
                DropdownMenuItem(value: 'year', child: Text('This year')),
              ],
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardSummary extends StatelessWidget {
  const _DashboardSummary({
    required this.totalProducts,
    required this.totalCategories,
    required this.totalUsers,
    required this.lowStockAlerts,
  });

  final int totalProducts;
  final int totalCategories;
  final int totalUsers;
  final int lowStockAlerts;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _SummaryCard(
          icon: Icons.inventory_2_rounded,
          title: 'Products',
          value: totalProducts.toString(),
        ),
        _SummaryCard(
          icon: Icons.category_rounded,
          title: 'Categories',
          value: totalCategories.toString(),
        ),
        _SummaryCard(
          icon: Icons.people_alt_rounded,
          title: 'Customers',
          value: totalUsers.toString(),
        ),
        _SummaryCard(
          icon: Icons.warning_amber_rounded,
          title: 'Low stock',
          value: lowStockAlerts.toString(),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF3F4F6),
            ),
            child: Icon(icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
