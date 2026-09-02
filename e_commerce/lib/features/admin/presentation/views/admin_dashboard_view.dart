import 'package:e_commerce/core/helper_function/shared_prefs_helper.dart';
import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_dashboard_state.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_navigation_cubit.dart';
import 'package:e_commerce/features/admin/presentation/views/admin_categories_view.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_categories.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_header.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_inventory.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_recent_orders.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_sales_overview.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_stats.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_sidebar.dart';
import 'package:e_commerce/features/admin/presentation/views/admin_overview_view.dart';
import 'package:e_commerce/features/admin/presentation/views/admin_customers_view.dart';
import 'package:e_commerce/features/admin/presentation/views/admin_products_view.dart';
import 'package:e_commerce/features/admin/presentation/views/admin_workspace_view.dart';
import 'package:e_commerce/features/admin/presentation/views/admin_settings_view.dart';
import 'package:e_commerce/features/admin/presentation/views/admin_earnings_view.dart';
import 'package:e_commerce/features/admin/presentation/views/admin_payouts_view.dart';
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
        BlocProvider(
          create: (_) => getIt<AdminDashboardCubit>()..loadDashboard(),
        ),
        BlocProvider(create: (_) => AdminNavigationCubit()),
      ],
      child: const _AdminDashboardBody(),
    );
  }
}

class _AdminDashboardBody extends StatelessWidget {
  const _AdminDashboardBody();

  Widget _content(int index, bool wide, bool medium) {
    switch (index) {
      case 0:
        return _dashboard(wide, medium);
      case 1:
        return const AdminOverviewView();

      case 2:
        return const AdminCustomersView();

      case 3:
        return const AdminProductsView();

      case 4:
        return const AdminCategoriesView();

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

  Widget _dashboard(bool wide, bool medium) {
    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, state) {
        if (state is AdminDashboardLoading || state is AdminDashboardInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AdminDashboardFailure) {
          return Center(child: Text(state.message));
        }
        final data = (state as AdminDashboardLoaded).data;
        return RefreshIndicator(
          onRefresh: () => context.read<AdminDashboardCubit>().loadDashboard(
            period: data.period,
          ),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(wide ? 28 : 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdminDashboardHeader(isWide: wide),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Period: '),
                    DropdownButton<String>(
                      value: data.period,
                      items: const [
                        DropdownMenuItem(value: 'week', child: Text('Week')),
                        DropdownMenuItem(value: 'month', child: Text('Month')),
                        DropdownMenuItem(value: 'year', child: Text('Year')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          context.read<AdminDashboardCubit>().loadDashboard(
                            period: value,
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AdminDashboardStats.fromData(data: data),
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
          builder: (context, index) {
            final sidebar = AdminSidebar(
              selectedIndex: index,
              onItemSelected: (i) {
                context.read<AdminNavigationCubit>().updateIndex(i);
                if (!sidebarVisible) Navigator.of(context).pop();
              },
            );
            return Scaffold(
              backgroundColor: const Color(0xFFF3F5F9),
              drawer: sidebarVisible ? null : Drawer(child: sidebar),
              body: SafeArea(
                child: Row(
                  children: [
                    if (sidebarVisible) sidebar,
                    Expanded(child: _content(index, wide, medium)),
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
