import 'dart:developer';

import 'package:e_commerce/features/address/presentation/views/map_view.dart';
import 'package:e_commerce/features/cart/domain/entity/cart_entity.dart';
import 'package:e_commerce/core/widgets/custom_app_bar.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:e_commerce/features/cart/presentation/view/widgets/cart_summary.dart';
import 'package:e_commerce/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:e_commerce/features/checkout/presentation/cubit/checkout_state.dart';
import 'package:e_commerce/features/order/presenation/modelview/cubit/order_cubit.dart';
import 'package:e_commerce/features/order/presenation/modelview/cubit/order_state.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/order_success_view.dart';
import 'package:e_commerce/features/payment/data/data_source/paymob_remote_data_source.dart';
import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutViewBody extends StatelessWidget {
  const CheckoutViewBody({super.key, required this.cart});

  final CartEntity cart;

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderCreated) {
          context.read<CartCubit>().removeAllFromCart();

          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => AlertDialog(
              title: const Text('Success'),
              content: Text(
                'Your ${state.order.paymentMethod == 'card' ? 'card' : 'cash'} order was created successfully.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const OrderSuccessView(),
                      ),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }

        if (state is OrderError) {
          log(state.message);

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: CustomAppBar(title: 'Checkout')),

            SliverToBoxAdapter(
              child: BlocBuilder<CheckoutCubit, CheckoutState>(
                builder: (context, state) {
                  if (state is CheckoutLoading || state is CheckoutInitial) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state is CheckoutError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final loaded = state as CheckoutLoaded;

                  return Column(
                    children: [
                      const SizedBox(height: 16),

                      _buildOptionCard(
                        context,
                        title: 'Shipping Address',
                        value: loaded.selectedAddress == null
                            ? 'Add Shipping Address'
                            : '${loaded.selectedAddress!.street}, ${loaded.selectedAddress!.city}',
                        onTap: () => _showAddressPicker(context, loaded),
                      ),

                      const SizedBox(height: 16),

                      _buildOptionCard(
                        context,
                        title: 'Payment Method',
                        value:
                            loaded.selectedPaymentType ==
                                CheckoutPaymentType.cash
                            ? 'Cash on Delivery'
                            : 'Paymob card',
                        onTap: () => _showPaymentPicker(context, loaded),
                      ),
                    ],
                  );
                },
              ),
            ),

            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CartSummary(cart: cart, showCoupon: false),

                    const SizedBox(height: 28),

                    _buildPlaceOrderButton(context),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, checkoutState) {
        final loaded = checkoutState is CheckoutLoaded ? checkoutState : null;

        final canPlaceOrder = loaded?.selectedAddress != null;

        final total = cart.subtotal ?? 0.0;

        return BlocBuilder<OrderCubit, OrderState>(
          builder: (context, orderState) {
            final isLoading = orderState is OrderLoading;

            return SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: canPlaceOrder && !isLoading
                    ? () => _placeOrder(context, loaded!)
                    : null,
                style: FilledButton.styleFrom(
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Row(
                          children: [
                            Text(
                              '\$${total.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              'Place Order',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _placeOrder(BuildContext context, CheckoutLoaded state) async {
    final address = state.selectedAddress;

    if (address == null) {
      return;
    }

    final shippingAddress = {
      'street': address.street,
      'city': address.city,
      'country': address.country,
      'postalCode': address.postalCode,
    };

    final products = cart.items
        .map(
          (item) => {
            'product': item.productId,
            'variant': item.variantId,
            'quantity': item.quantity,

            // Send price for backend validation.
            if (item.price != null) 'price': item.price,
          },
        )
        .toList();

    // CASH PAYMENT
    if (state.selectedPaymentType == CheckoutPaymentType.cash) {
      context.read<OrderCubit>().createOrder(
        products: products,
        totalPrice: cart.subtotal ?? 0,
        shippingAddress: shippingAddress,
        paymentMethod: 'cash',
      );

      return;
    }

    // CARD PAYMENT
    if (state.selectedPaymentType == CheckoutPaymentType.card) {
      try {
        /*
         * Do NOT create the order here.
         *
         * We create only a Paymob payment session.
         */

        final paymentData = await getIt<PaymobRemoteDataSource>()
            .createPaymentSession(
              products: products,
              totalPrice: cart.subtotal ?? 0,
              shippingAddress: shippingAddress,
            );

        final responseData = paymentData['data'] as Map<String, dynamic>?;

        final paymentUrl = responseData?['checkoutUrl'] as String?;

        if (paymentUrl == null || paymentUrl.trim().isEmpty) {
          throw Exception('No payment URL returned from server');
        }

        log('PAYMOB URL: $paymentUrl');

        final launched = await launchUrl(
          Uri.parse(paymentUrl),
          mode: LaunchMode.externalApplication,
        );

        if (!launched) {
          throw Exception('Could not open Paymob payment page');
        }

        /*
         * IMPORTANT:
         *
         * There is intentionally NO createOrder()
         * here.
         *
         * The backend creates the order only after
         * Paymob confirms successful payment.
         */
      } catch (e) {
        log('PAYMENT ERROR: $e');

        if (!context.mounted) {
          return;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
      }
    }
  }

  void _showAddressPicker(BuildContext context, CheckoutLoaded state) {
    final cubit = context.read<CheckoutCubit>();

    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.addresses.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No saved addresses yet.'),
                ),

              for (final address in state.addresses)
                ListTile(
                  title: Text('${address.street}, ${address.city}'),
                  trailing: address.id == state.selectedAddress?.id
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    cubit.selectAddress(address);
                    Navigator.of(sheetContext).pop();
                  },
                ),

              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Add New Address'),
                onTap: () {
                  Navigator.of(sheetContext).pop();

                  Navigator.pushNamed(context, MapView.routeName);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPaymentPicker(BuildContext context, CheckoutLoaded state) {
    final cubit = context.read<CheckoutCubit>();

    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  leading: const Icon(Icons.money_outlined),
                  title: const Text('Cash on Delivery'),
                  trailing:
                      state.selectedPaymentType == CheckoutPaymentType.cash
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    cubit.selectCashPayment();

                    Navigator.of(sheetContext).pop();
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.credit_card_outlined),
                  title: const Text('Paymob card'),
                  trailing:
                      state.selectedPaymentType == CheckoutPaymentType.card
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    cubit.selectcardPayment();

                    Navigator.of(sheetContext).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black45,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 25,
                color: Colors.black87,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
