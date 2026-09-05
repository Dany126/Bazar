import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_earnings_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_earnings_state.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_sales_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminEarningsView
    extends StatelessWidget {
  const AdminEarningsView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocProvider(
      create: (_) =>
          getIt<AdminEarningsCubit>()
            ..loadEarnings(
              period: 'month',
            ),
      child:
          const _AdminEarningsBody(),
    );
  }
}

class _AdminEarningsBody
    extends StatelessWidget {
  const _AdminEarningsBody();

  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocBuilder<
        AdminEarningsCubit,
        AdminEarningsState>(
      builder: (context, state) {
        if (state
                is AdminEarningsInitial ||
            state
                is AdminEarningsLoading) {
          return const Center(
            child:
                CircularProgressIndicator(),
          );
        }

        if (state
            is AdminEarningsFailure) {
          return Center(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Text(
                  state.message,
                  textAlign:
                      TextAlign.center,
                ),
                const SizedBox(
                  height: 16,
                ),
                FilledButton(
                  onPressed: () {
                    context
                        .read<
                            AdminEarningsCubit>()
                        .loadEarnings();
                  },
                  child:
                      const Text(
                    'Retry',
                  ),
                ),
              ],
            ),
          );
        }

        final loaded =
            state
                as AdminEarningsLoaded;

        final data =
            loaded.data;

        return RefreshIndicator(
          onRefresh: () {
            return context
                .read<
                    AdminEarningsCubit>()
                .loadEarnings(
                  period: data.period,
                );
          },
          child:
              SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(),
            padding:
                const EdgeInsets.all(
              24,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  'Earnings',
                  style: Theme.of(
                    context,
                  )
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                        fontWeight:
                            FontWeight.w700,
                      ),
                ),

                const SizedBox(
                  height: 20,
                ),

                _EarningsPeriodFilter(
                  selectedPeriod:
                      data.period,
                ),

                const SizedBox(
                  height: 24,
                ),

                _RevenueSummary(
                  totalRevenue:
                      data.totalRevenue,
                  periodRevenue:
                      data.periodRevenue,
                  period:
                      data.period,
                  currency:
                      data.store.currency,
                ),

                const SizedBox(
                  height: 28,
                ),

                AdminDashboardSalesOverview(
                  points:
                      data.revenueChart,
                  period:
                      data.period,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/*
|--------------------------------------------------------------------------
| PERIOD FILTER
|--------------------------------------------------------------------------
*/

class _EarningsPeriodFilter
    extends StatelessWidget {
  const _EarningsPeriodFilter({
    required this.selectedPeriod,
  });

  final String selectedPeriod;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          12,
        ),
        border: Border.all(
          color:
              const Color(0xffE5E7EB),
        ),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_month_rounded,
            size: 20,
          ),

          const SizedBox(
            width: 10,
          ),

          const Text(
            'Period',
            style: TextStyle(
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          DropdownButtonHideUnderline(
            child:
                DropdownButton<String>(
              value:
                  selectedPeriod,

              isDense: true,

              items: const [
                DropdownMenuItem(
                  value: 'week',
                  child:
                      Text('This week'),
                ),
                DropdownMenuItem(
                  value: 'month',
                  child:
                      Text('This month'),
                ),
                DropdownMenuItem(
                  value: 'year',
                  child:
                      Text('This year'),
                ),
              ],

              onChanged:
                  (value) {
                if (value ==
                    null) {
                  return;
                }

                context
                    .read<
                        AdminEarningsCubit>()
                    .loadEarnings(
                      period: value,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/*
|--------------------------------------------------------------------------
| REVENUE SUMMARY
|--------------------------------------------------------------------------
*/

class _RevenueSummary
    extends StatelessWidget {
  const _RevenueSummary({
    required this.totalRevenue,
    required this.periodRevenue,
    required this.period,
    required this.currency,
  });

  final double totalRevenue;
  final double periodRevenue;
  final String period;
  final String currency;

  String _periodLabel() {
    switch (period) {
      case 'week':
        return 'This week';

      case 'year':
        return 'This year';

      case 'month':
      default:
        return 'This month';
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      children: [
        Expanded(
          child: _RevenueCard(
            title:
                'Total Revenue',
            value:
                '${totalRevenue.toStringAsFixed(2)} $currency',
          ),
        ),

        const SizedBox(
          width: 16,
        ),

        Expanded(
          child: _RevenueCard(
            title:
                '${_periodLabel()} Revenue',
            value:
                '${periodRevenue.toStringAsFixed(2)} $currency',
          ),
        ),
      ],
    );
  }
}

class _RevenueCard
    extends StatelessWidget {
  const _RevenueCard({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color:
              const Color(0xffE8EAF0),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            value,
            style:
                const TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}