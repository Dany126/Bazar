import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/core/widgets/custom_button.dart';
import 'package:e_commerce/features/order/presenation/modelview/cubit/order_cubit.dart';
import 'package:e_commerce/features/order/presenation/modelview/cubit/order_state.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/order_card.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/order_detail_view.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/order_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const kOrderAccentColor = Color(0xFF7B61FF);

enum OrderStatus { all, processing, shipped, delivered, returned, cancelled }

class OrderViewBody extends StatefulWidget {
  const OrderViewBody({super.key});

  @override
  State<OrderViewBody> createState() => _OrderViewBodyState();
}

class _OrderViewBodyState extends State<OrderViewBody> {
  OrderStatus selectedFilter = OrderStatus.all;

  void onFilterSelected(OrderStatus filter) {
    if (filter == selectedFilter) {
      return;
    }

    setState(() {
      selectedFilter = filter;
    });

    context.read<OrderCubit>().getMyOrders(
      userId: '6a79c81d8a67e79b3d94c9f4',
      filter: filter,
    );
  }

  String get emptyMessage {
    switch (selectedFilter) {
      case OrderStatus.all:
        return 'No orders yet';

      case OrderStatus.processing:
        return 'No processing orders';

      case OrderStatus.shipped:
        return 'No shipped orders';

      case OrderStatus.delivered:
        return 'No delivered orders';

      case OrderStatus.returned:
        return 'No returned orders';

      case OrderStatus.cancelled:
        return 'No cancelled orders';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),

        OrderFilterBar(
          onFilterSelected: onFilterSelected,
          selectedFilter: selectedFilter,
        ),

        const SizedBox(height: 8),

        Expanded(
          child: BlocBuilder<OrderCubit, OrderState>(
            builder: (context, state) {
              if (state is OrderLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is OrderError) {
                return _buildErrorState(context, state.message);
              }

              if (state is OrdersLoaded) {
                if (state.orders.isEmpty) {
                  return _buildEmptyState(context);
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.orders.length,
                  separatorBuilder: (_, __) {
                    return const SizedBox(height: 12);
                  },
                  itemBuilder: (context, index) {
                    final order = state.orders[index];

                    return OrderCard(
                      order: order,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => OrderDetailView(order: order),
                          ),
                        );
                      },
                    );
                  },
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.assetsImagesCheckOut, height: 150),

            const SizedBox(height: 16),

            Text(
              emptyMessage,
              style: AppStyles.textStylesRegular16(context),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            if (selectedFilter != OrderStatus.all)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: CustomButton(
                  onTap: () {
                    setState(() {
                      selectedFilter = OrderStatus.all;
                    });

                    context.read<OrderCubit>().getMyOrders(
                      userId: '6a79c81d8a67e79b3d94c9f4',
                      filter: OrderStatus.all,
                    );
                  },
                  text: 'Explore all orders',
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),

            const SizedBox(height: 16),

            Text(
              message,
              style: AppStyles.textStylesRegular16(context),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: CustomButton(
                onTap: () {
                  context.read<OrderCubit>().getMyOrders(
                    userId: '6a79c81d8a67e79b3d94c9f4',
                    filter: selectedFilter,
                  );
                },
                text: 'Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
