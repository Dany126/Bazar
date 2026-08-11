import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/core/widgets/custom_button.dart';

import 'package:e_commerce/features/order/domin/entity/order_entity.dart';

import 'package:e_commerce/features/order/presenation/view/widgets/order_card.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/order_detail_view.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/order_filter_bar.dart';

import 'package:flutter/material.dart';

const kOrderAccentColor = Color(0xFF7B61FF);

enum OrderStatus { all, processing, shipped, delivered, returned, cancelled }

class OrderViewBody extends StatefulWidget {
  const OrderViewBody({super.key});

  @override
  State<OrderViewBody> createState() => _OrderViewBodyState();
}

class _OrderViewBodyState extends State<OrderViewBody> {
  OrderStatus selectedFilter = OrderStatus.processing;

  // TEMP dummy data — remove once wired up to the cubit.
  // Swap this list to `[]` to preview the empty state.
  // NOTE: ProductEntity's own fields (id/name/price/imageUrl) are guessed below —
  // adjust the ProductEntity(...) constructors to match your real entity.
  final List<OrderEntity> orders = kOrders;

  void onFilterSelected(OrderStatus filter) {
    if (filter == selectedFilter) return;

    setState(() {
      selectedFilter = filter;
    });
  }

  List<OrderEntity> get filteredOrders {
    if (selectedFilter == OrderStatus.all) return orders;
    return orders
        .where((order) => order.orderStatus == selectedFilter.name)
        .toList();
  }

  String get emptyMessage {
    switch (selectedFilter) {
      case OrderStatus.all:
        return 'No orders';
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
    final visibleOrders = filteredOrders;

    return Column(
      children: [
        const SizedBox(height: 12),
        OrderFilterBar(
          onFilterSelected: onFilterSelected,
          selectedFilter: selectedFilter,
        ),
        Expanded(
          child: visibleOrders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Assets.assetsImagesCheckOut),
                      const SizedBox(height: 12),
                      Text(
                        emptyMessage,
                        style: AppStyles.textStylesRegular16(context),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: CustomButton(
                          onTap: () {
                            selectedFilter = OrderStatus.all;
                            setState(() {});
                          },
                          text: "Explore all orders",
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: visibleOrders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = visibleOrders[index];
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
                ),
        ),
      ],
    );
  }
}
