import 'package:e_commerce/core/helper_function/shared_prefs_helper.dart';
import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_dashboard_state.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_navigation_cubit.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_categories.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_header.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_inventory.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_recent_orders.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_sales_overview.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_stats.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_sidebar.dart';

// Import new views
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
    // Check role stored after authentication.
    final isAdmin = SharedPrefsHelper.isAdmin();

    // Prevent normal users from opening the dashboard.
    if (!isAdmin) {
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

  Widget _buildContentForIndex(int index, bool isWide, bool isMedium) {
    switch (index) {
      case 0: // Dashboard
        return _buildDashboardTab(isWide, isMedium);
      case 1: // Overview
        return const AdminOverviewView();
      case 2: // Customers
        return const AdminCustomersView();
      case 3: // Products
        return const AdminProductsView();
      case 4: // Workspace
        return const AdminWorkspaceView();
      case 5: // Settings
        return const AdminSettingsView();
      case 6: // Earnings
        return const AdminEarningsView();
      case 7: // Payouts
        return const AdminPayoutsView();
      default:
        return const Center(child: Text('Not Implemented'));
    }
  }

  Widget _buildDashboardTab(bool isWide, bool isMedium) {
    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, state) {
        if (state is AdminDashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }
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

        final data = state is AdminDashboardLoaded
            ? state.data
            : AdminDashboardData.empty();

        return SingleChildScrollView(
          padding: EdgeInsets.all(isWide ? 28 : 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminDashboardHeader(isWide: isWide),
              const SizedBox(height: 24),
              AdminDashboardStats.fromData(data: data),
              const SizedBox(height: 24),
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: AdminDashboardSalesOverview(bars: data.salesTrend),
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
                      child: AdminDashboardInventory(items: data.lowInventory),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1100;
        final isMedium = constraints.maxWidth >= 760;
        final showSidebar = constraints.maxWidth >= 900;

        return BlocBuilder<AdminNavigationCubit, int>(
          builder: (context, selectedIndex) {
            final sidebar = AdminSidebar(
              selectedIndex: selectedIndex,
              onItemSelected: (index) {
                context.read<AdminNavigationCubit>().updateIndex(index);
                if (!showSidebar) {
                  Navigator.of(context).pop(); // Close drawer on mobile
                }
              },
            );

            return Scaffold(
              backgroundColor: const Color(0xFFF3F5F9),
              drawer: showSidebar ? null : Drawer(child: sidebar),
              body: SafeArea(
                child: Row(
                  children: [
                    if (showSidebar) sidebar,
                    Expanded(
                      child: _buildContentForIndex(
                        selectedIndex,
                        isWide,
                        isMedium,
                      ),
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
