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

  String _title(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Customers';
      case 2:
        return 'Products';
      case 3:
        return 'Categories';
      case 4:
        return 'Orders';
      case 5:
        return 'Workspace';
      case 6:
        return 'Settings';
      case 7:
        return 'Earnings';
      case 8:
        return 'Payouts';
      default:
        return 'Dashboard';
    }
  }

  Widget _content(BuildContext context, int index, bool wide, bool tablet) {
    switch (index) {
      case 0:
        return _dashboard(context, wide, tablet);

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

  Widget _dashboard(BuildContext context, bool wide, bool tablet) {
    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, state) {
        if (state is AdminDashboardInitial || state is AdminDashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AdminDashboardFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 12),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<AdminDashboardCubit>().loadDashboard();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
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

                _PeriodSelector(
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

                AdminDashboardInventory(items: data.lowInventory),
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
        final width = constraints.maxWidth;

        final desktop = width >= 1100;

        final tablet = width >= 600;

        final showDrawer = !desktop;

        return BlocBuilder<AdminNavigationCubit, int>(
          builder: (context, selectedIndex) {
            final sidebar = AdminSidebar(
              selectedIndex: selectedIndex,
              onItemSelected: (index) {
                context.read<AdminNavigationCubit>().updateIndex(index);

                if (showDrawer) {
                  Navigator.of(context).pop();
                }
              },
            );

            return Scaffold(
              backgroundColor: const Color(0xFFF3F5F9),

              drawer: showDrawer
                  ? Drawer(
                      width: tablet ? 320 : width * .82,
                      child: SafeArea(child: sidebar),
                    )
                  : null,

              body: SafeArea(
                child: Row(
                  children: [
                    if (desktop) sidebar,

                    Expanded(
                      child: Column(
                        children: [
                          if (showDrawer)
                            _MobileAdminBar(title: _title(selectedIndex)),

                          Expanded(
                            child: _content(
                              context,
                              selectedIndex,
                              desktop,
                              tablet,
                            ),
                          ),
                        ],
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

class _MobileAdminBar extends StatelessWidget {
  const _MobileAdminBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
          ),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Open navigation',
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu_rounded),
              ),

              const SizedBox(width: 8),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({required this.period, required this.onChanged});

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
