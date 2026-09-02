import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/features/order/domin/entity/order_entity.dart';
import 'package:e_commerce/features/order/data/model/time_line_step_model_data.dart';
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
      'placed',
      'confirmed',
      'shipped',
      'delivered',
      'cancelled',
    ];

    int currentIndex = statusOrder.indexOf(order.orderStatus);

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
          overflow: TextOverflow.ellipsis,
          style: AppStyles.textStylesBold22Mono(
            context,
          ).copyWith(color: Colors.black),
        ),

        // Don't use 18% of the screen for the leading widget.
        // It can create bad spacing/overflow on responsive layouts.
        leadingWidth: 56,

        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            final isDesktop = width >= 900;

            final contentWidth = isDesktop ? width * 0.5 : width;

            final horizontalPadding = width < 500
                ? 12.0
                : width < 900
                ? 20.0
                : 0.0;

            return Center(
              child: SizedBox(
                width: contentWidth,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),

                        // =====================================================
                        // ORDER STATUS
                        // =====================================================
                        if (isCancelled) ...[
                          SizedBox(
                            width: double.infinity,
                            child: CancelledOrderCard(),
                          ),

                          const SizedBox(height: 20),
                        ] else ...[
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ..._steps.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final step = entry.value;

                                  return SizedBox(
                                    width: double.infinity,
                                    child: TimelineTile(
                                      label: step.label,
                                      dateLabel: dateLabel,
                                      completed: step.completed,
                                      isFirst: index == 0,
                                      isLast: index == _steps.length - 1,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        // =====================================================
                        // ORDER ITEMS
                        // =====================================================
                        Text(
                          'Order Items',
                          style: AppStyles.textStylesBold16Mono(
                            context,
                          ).copyWith(color: Colors.black),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: OrderItemsCard(order: order),
                        ),

                        const SizedBox(height: 20),

                        // =====================================================
                        // SHIPPING DETAILS
                        // =====================================================
                        Text(
                          'Shipping details',
                          style: AppStyles.textStylesBold16Mono(
                            context,
                          ).copyWith(color: Colors.black),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: ShippingDetails(order: order),
                        ),

                        const SizedBox(height: 20),

                        // =====================================================
                        // PAYMENT DETAILS
                        // =====================================================
                        Text(
                          'Payment details',
                          style: AppStyles.textStylesBold16Mono(
                            context,
                          ).copyWith(color: Colors.black),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: PaymentDetails(order: order),
                        ),

                        const SizedBox(height: 20),

                        // =====================================================
                        // TOTAL
                        // =====================================================
                        SizedBox(
                          width: double.infinity,
                          child: TotalPrice(totalPrice: order.totalPrice),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
