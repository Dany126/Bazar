import 'dart:async';
import 'dart:developer';

import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/widgets/custom_app_bar.dart';

import 'package:e_commerce/features/address/presentation/views/map_view.dart';

import 'package:e_commerce/features/cart/domain/entity/cart_entity.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:e_commerce/features/cart/presentation/view/widgets/cart_summary.dart';

import 'package:e_commerce/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:e_commerce/features/checkout/presentation/cubit/checkout_state.dart';

import 'package:e_commerce/features/order/presenation/modelview/cubit/order_cubit.dart';
import 'package:e_commerce/features/order/presenation/modelview/cubit/order_state.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/order_success_view.dart';

import 'package:e_commerce/features/payment/domain/use_case/create_paymob_payment_use_case.dart';
import 'package:e_commerce/features/payment/domain/use_case/get_paymob_payment_status_use_case.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:url_launcher/url_launcher.dart';

class CheckoutViewBody extends StatelessWidget {
  const CheckoutViewBody({super.key, required this.cart});

  final CartEntity cart;

  @override
  Widget build(BuildContext context) {
    /*
     * ========================================================
     * CASH ORDER LISTENER
     * ========================================================
     *
     * Card orders are NOT handled by OrderCubit here.
     *
     * Card orders are created by the backend webhook.
     */
    return BlocListener<OrderCubit, OrderState>(
      listener: (context, state) {
        /*
         * Cash order successfully created.
         */
        if (state is OrderCreated) {
          /*
           * Clear cart.
           */
          context.read<CartCubit>().removeAllFromCart();

          /*
           * Show success dialog.
           */
          showDialog<void>(
            context: context,

            barrierDismissible: false,

            builder: (dialogContext) {
              return AlertDialog(
                title: const Text('Success'),

                content: const Text(
                  'Your cash order was created successfully.',
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
              );
            },
          );
        }

        /*
         * Cash order failed.
         */
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

            /*
             * =================================================
             * CHECKOUT OPTIONS
             * =================================================
             */
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

                      /*
                       * Shipping address.
                       */
                      _buildOptionCard(
                        context,

                        title: 'Shipping Address',

                        value: loaded.selectedAddress == null
                            ? 'Add Shipping Address'
                            : '${loaded.selectedAddress!.street}, ${loaded.selectedAddress!.city}',

                        onTap: () => _showAddressPicker(context, loaded),
                      ),

                      const SizedBox(height: 16),

                      /*
                       * Payment method.
                       */
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

            /*
             * =================================================
             * SUMMARY + PLACE ORDER
             * =================================================
             */
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

  /*
   * ============================================================
   * PLACE ORDER BUTTON
   * ============================================================
   */
  Widget _buildPlaceOrderButton(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, checkoutState) {
        final loaded = checkoutState is CheckoutLoaded ? checkoutState : null;

        final canPlaceOrder = loaded?.selectedAddress != null;

        final total = cart.subtotal ?? 0.0;

        return BlocBuilder<OrderCubit, OrderState>(
          builder: (context, orderState) {
            /*
             * Cash loading.
             *
             * Card loading is handled separately because
             * it does not use OrderCubit.
             */
            final orderLoading = orderState is OrderLoading;

            return SizedBox(
              width: double.infinity,

              height: 50,

              child: FilledButton(
                onPressed: canPlaceOrder && !orderLoading
                    ? () => _placeOrder(context, loaded!)
                    : null,

                style: FilledButton.styleFrom(
                  elevation: 0,

                  padding: EdgeInsets.zero,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),

                child: orderLoading
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

  /*
   * ============================================================
   * PLACE ORDER
   * ============================================================
   *
   * CASH:
   *
   * createOrder()
   *
   *
   * CARD:
   *
   * createPaymentSession()
   *       ↓
   * Paymob
   *       ↓
   * waitForPayment()
   *       ↓
   * webhook
   *       ↓
   * Order created
   */
  Future<void> _placeOrder(BuildContext context, CheckoutLoaded state) async {
    final address = state.selectedAddress;

    if (address == null) {
      return;
    }

    /*
     * --------------------------------------------------------
     * Shipping address
     * --------------------------------------------------------
     */
    final shippingAddress = {
      'street': address.street,

      'city': address.city,

      'country': address.country,

      'postalCode': address.postalCode,
    };

    /*
     * --------------------------------------------------------
     * Build products
     * --------------------------------------------------------
     */
    final products = cart.items.map((item) {
      return {
        'product': item.productId,

        'variant': item.variantId,

        'quantity': item.quantity,

        /*
                   * Price is sent only for reference/backend
                   * validation.
                   *
                   * Backend still gets the REAL price from
                   * MongoDB.
                   */
        if (item.price != null) 'price': item.price,
      };
    }).toList();

    /*
     * ========================================================
     * CASH
     * ========================================================
     *
     * Cash orders can be created immediately because there is
     * no external payment that must succeed first.
     */
    if (state.selectedPaymentType == CheckoutPaymentType.cash) {
      context.read<OrderCubit>().createOrder(
        products: products,

        /*
         * Order backend recalculates/validates this.
         */
        totalPrice: cart.subtotal ?? 0,

        shippingAddress: shippingAddress,

        paymentMethod: 'cash',
      );

      return;
    }

    /*
     * ========================================================
     * CARD
     * ========================================================
     */
    if (state.selectedPaymentType == CheckoutPaymentType.card) {
      await _startCardPayment(
        context: context,

        products: products,

        shippingAddress: shippingAddress,
      );
    }
  }

  /*
   * ============================================================
   * START CARD PAYMENT
   * ============================================================
   */
  Future<void> _startCardPayment({
    required BuildContext context,

    required List<Map<String, dynamic>> products,

    required Map<String, dynamic> shippingAddress,
  }) async {
    try {
      /*
       * Show a temporary loading dialog while we ask our
       * backend to create the Paymob session.
       */
      _showLoadingDialog(context, 'Preparing payment...');

      /*
       * Get the UseCase through GetIt.
       */
      final createPaymentSession = getIt<CreatePaymobPaymentUseCase>();

      /*
       * IMPORTANT:
       *
       * There is NO totalPrice parameter here.
       *
       * Backend calculates the real total.
       */
      final result = await createPaymentSession(
        products: products,

        shippingAddress: shippingAddress,
      );

      /*
       * Close loading dialog.
       */
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      /*
       * Handle result.
       */
      await result.fold(
        /*
         * Backend failed.
         */
        (failure) async {
          if (!context.mounted) {
            return;
          }

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(failure.message)));
        },

        /*
         * Payment session created.
         */
        (data) async {
          /*
           * API response:
           *
           * {
           *   status: Success,
           *   data: {
           *     paymentSessionId,
           *     checkoutUrl,
           *     clientSecret,
           *     totalPrice
           *   }
           * }
           */
          final responseData = data['data'] as Map<String, dynamic>?;

          if (responseData == null) {
            throw Exception('Invalid payment response');
          }

          final paymentSessionId = responseData['paymentSessionId']?.toString();

          final paymentUrl = responseData['checkoutUrl']?.toString();

          /*
           * Make sure backend returned everything needed.
           */
          if (paymentSessionId == null || paymentSessionId.isEmpty) {
            throw Exception('Payment session ID was not returned');
          }

          if (paymentUrl == null || paymentUrl.isEmpty) {
            throw Exception('Payment URL was not returned');
          }

          log('PAYMENT SESSION: $paymentSessionId');

          log('PAYMOB URL: $paymentUrl');

          /*
           * --------------------------------------------------
           * Open Paymob
           * --------------------------------------------------
           */
          final launched = await launchUrl(
            Uri.parse(paymentUrl),

            mode: LaunchMode.externalApplication,
          );

          if (!launched) {
            throw Exception('Could not open Paymob payment page');
          }

          /*
           * --------------------------------------------------
           * Wait for webhook result
           * --------------------------------------------------
           *
           * We DO NOT create an Order here.
           */
          await _waitForPayment(
            context: context,

            paymentSessionId: paymentSessionId,
          );
        },
      );
    } catch (error) {
      /*
       * Close loading dialog if an exception occurred while
       * it was still visible.
       *
       * We check canPop to avoid popping the checkout screen.
       */
      if (context.mounted) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Payment failed: $error')));
      }

      log('PAYMENT ERROR: $error');
    }
  }

  /*
   * ============================================================
   * WAIT FOR PAYMENT
   * ============================================================
   *
   * Flutter periodically asks:
   *
   * GET /payments/sessions/:id/status
   *
   * Backend status changes:
   *
   * pending
   *    ↓
   * paid
   *
   * The webhook is responsible for changing it to paid and
   * creating the real Order.
   */
  Future<void> _waitForPayment({
    required BuildContext context,

    required String paymentSessionId,
  }) async {
    /*
     * Get status UseCase.
     */
    final getPaymentStatus = getIt<GetPaymobPaymentStatusUseCase>();

    /*
     * Maximum:
     *
     * 60 attempts × 5 seconds
     *
     * = 5 minutes
     */
    const maxAttempts = 60;

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      /*
       * Wait before checking.
       *
       * This gives Paymob/webhook time to finish.
       */
      await Future.delayed(const Duration(seconds: 5));

      /*
       * If user navigated away, stop.
       */
      if (!context.mounted) {
        return;
      }

      /*
       * Ask backend for current status.
       */
      final result = await getPaymentStatus(paymentSessionId: paymentSessionId);

      /*
       * Convert response to status.
       */
      final status = result.fold(
        /*
         * Temporary network/server failure.
         *
         * Return null and continue polling.
         */
        (_) => null,

        (data) {
          final responseData = data['data'] as Map<String, dynamic>?;

          return responseData?['status']?.toString();
        },
      );

      log('PAYMENT STATUS: $status');

      /*
       * ======================================================
       * PAYMENT SUCCESS
       * ======================================================
       */
      if (status == 'paid') {
        /*
         * IMPORTANT:
         *
         * At this point the webhook has:
         *
         * 1. verified Paymob
         * 2. created Order
         * 3. marked PaymentSession = paid
         */
        await _handlePaymentSuccess(context);

        return;
      }

      /*
       * ======================================================
       * PAYMENT FAILED
       * ======================================================
       */
      if (status == 'failed') {
        if (!context.mounted) {
          return;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Payment failed.')));

        return;
      }

      /*
       * ======================================================
       * PAYMENT EXPIRED
       * ======================================================
       */
      if (status == 'expired') {
        if (!context.mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment session expired.')),
        );

        return;
      }
    }

    /*
     * ========================================================
     * TIMEOUT
     * ========================================================
     *
     * VERY IMPORTANT:
     *
     * We do NOT create an Order.
     *
     * The payment result may still arrive later through webhook.
     */
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Payment is still being processed. Please check your orders shortly.',
          ),
        ),
      );
    }
  }

  /*
   * ============================================================
   * PAYMENT SUCCESS UI
   * ============================================================
   */
  Future<void> _handlePaymentSuccess(BuildContext context) async {
    /*
     * Clear cart only after backend says paid.
     */
    context.read<CartCubit>().removeAllFromCart();

    if (!context.mounted) {
      return;
    }

    /*
     * Show success dialog.
     */
    await showDialog<void>(
      context: context,

      barrierDismissible: false,

      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Payment successful'),

          content: const Text(
            'Your payment was completed and your order was created successfully.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const OrderSuccessView()),
                );
              },

              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /*
   * ============================================================
   * LOADING DIALOG
   * ============================================================
   */
  void _showLoadingDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,

      barrierDismissible: false,

      builder: (_) {
        return PopScope(
          canPop: false,

          child: AlertDialog(
            content: Row(
              children: [
                const SizedBox(
                  width: 24,

                  height: 24,

                  child: CircularProgressIndicator(strokeWidth: 2),
                ),

                const SizedBox(width: 16),

                Expanded(child: Text(message)),
              ],
            ),
          ),
        );
      },
    );
  }

  /*
   * ============================================================
   * ADDRESS PICKER
   * ============================================================
   */
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

  /*
   * ============================================================
   * PAYMENT METHOD PICKER
   * ============================================================
   */
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
                /*
                 * Cash.
                 */
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

                /*
                 * Card.
                 */
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

  /*
   * ============================================================
   * OPTION CARD
   * ============================================================
   */
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
