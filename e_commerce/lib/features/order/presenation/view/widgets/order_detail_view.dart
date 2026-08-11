import 'package:e_commerce/core/utils/app_styles.dart';

import 'package:e_commerce/features/order/domin/entity/order_entity.dart';
import 'package:e_commerce/features/order/presenation/modelview/cubit/time_line_step_model_data.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/cancelled_order_card.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/order_items_card.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/payment_details.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/shipping_details.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/time_line_step_data.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/total_price.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailView extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailView({super.key, required this.order});

  List<TimelineStepDataModel> get _steps {
    const statusOrder = [
      'pending',
      'confirmed',
      'processing',
      'shipped',
      'delivered',
    ];

    int currentIndex = statusOrder.indexOf(order.orderStatus);

    // Cancelled orders should not continue the normal delivery timeline.
    if (currentIndex == -1) {
      currentIndex = 0;
    }

    final steps = [
      const TimelineStepDataModel(label: 'Delivered', statusIndex: 4),
      const TimelineStepDataModel(label: 'Shipped', statusIndex: 3),
      const TimelineStepDataModel(label: 'Order Confirmed', statusIndex: 1),
      const TimelineStepDataModel(label: 'Order Placed', statusIndex: 0),
    ];

    return steps
        .map(
          (step) => step.copyWith(completed: currentIndex >= step.statusIndex),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = order.createdAt != null
        ? DateFormat('d MMM').format(order.createdAt!)
        : '—';
    final isCancelled = order.orderStatus == 'cancelled';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Order #${order.id}',
          style: AppStyles.textStylesBold22Mono(
            context,
          ).copyWith(color: Colors.black),
        ),
        leadingWidth: MediaQuery.of(context).size.width * 0.18,
        leading: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Material(
            color: const Color(0xFFF2F2F5),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                Navigator.of(context).maybePop();
              },
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.chevron_left, size: 24),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // Header
                const SizedBox(height: 24),

                // Cancelled order
                if (isCancelled) ...[
                  CancelledOrderCard(),
                  const SizedBox(height: 20),
                ] else ...[
                  // Order Timeline
                  ..._steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;

                    return TimelineTile(
                      label: step.label,
                      dateLabel: dateLabel,
                      completed: step.completed,
                      isFirst: index == 0,
                      isLast: index == _steps.length - 1,
                    );
                  }),
                ],

                const SizedBox(height: 8),

                // Order Items
                Text(
                  'Order Items',
                  style: AppStyles.textStylesBold16Mono(
                    context,
                  ).copyWith(color: Colors.black),
                ),

                const SizedBox(height: 12),

                OrderItemsCard(order: order),

                const SizedBox(height: 20),

                // Shipping Details
                Text(
                  'Shipping details',
                  style: AppStyles.textStylesBold16Mono(
                    context,
                  ).copyWith(color: Colors.black),
                ),

                const SizedBox(height: 12),

                ShippingDetails(order: order),

                const SizedBox(height: 20),

                // Payment Details
                Text(
                  'Payment details',
                  style: AppStyles.textStylesBold16Mono(
                    context,
                  ).copyWith(color: Colors.black),
                ),

                const SizedBox(height: 12),

                PaymentDetails(order: order),

                const SizedBox(height: 20),

                // Total
                TotalPrice(totalPrice: order.totalPrice),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
