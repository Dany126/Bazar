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

    context.read<OrderCubit>().getMyOrders(filter: filter);
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

  double _getHorizontalPadding(double width) {
    if (width < 360) {
      return 12;
    }

    if (width < 600) {
      return 16;
    }

    if (width < 1000) {
      return 24;
    }

    return 32;
  }

  double _getMaxContentWidth(double width) {
    if (width < 600) {
      return double.infinity;
    }

    if (width < 1200) {
      return 850;
    }

    return 1000;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final horizontalPadding = _getHorizontalPadding(width);
    final maxContentWidth = _getMaxContentWidth(width);

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

                return ListView.builder(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    top: 8,
                    bottom: 24,
                  ),
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) {
                    final order = state.orders[index];

                    return Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxContentWidth),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: OrderCard(
                            order: order,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => OrderDetailView(order: order),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
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
    final width = MediaQuery.sizeOf(context).width;

    final imageSize = width < 360
        ? 110.0
        : width < 600
        ? 130.0
        : 150.0;

    final buttonWidth = width < 600 ? width * 0.75 : 320.0;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.assetsImagesCheckOut, height: imageSize),

            const SizedBox(height: 16),

            Text(
              emptyMessage,
              style: AppStyles.textStylesRegular16(context),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            if (selectedFilter != OrderStatus.all)
              SizedBox(
                width: buttonWidth,
                child: CustomButton(
                  onTap: () {
                    setState(() {
                      selectedFilter = OrderStatus.all;
                    });

                    context.read<OrderCubit>().getMyOrders(
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
    final width = MediaQuery.sizeOf(context).width;

    final buttonWidth = width < 600 ? width * 0.75 : 320.0;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: width < 600 ? 52 : 60,
              color: Colors.red,
            ),

            const SizedBox(height: 16),

            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Text(
                message,
                style: AppStyles.textStylesRegular16(context),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: buttonWidth,
              child: CustomButton(
                onTap: () {
                  context.read<OrderCubit>().getMyOrders(
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
