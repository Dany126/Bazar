import 'package:e_commerce/features/cart/domain/entity/cart_entity.dart';
import 'package:e_commerce/features/cart/presentation/view/widgets/cart_app_bar.dart';
import 'package:e_commerce/features/cart/presentation/view/widgets/cart_summary.dart';
import 'package:e_commerce/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:e_commerce/features/checkout/presentation/cubit/checkout_state.dart';
import 'package:e_commerce/features/order/presenation/modelview/cubit/order_cubit.dart';
import 'package:e_commerce/features/order/presenation/modelview/cubit/order_state.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/order_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutViewBody extends StatelessWidget {
  const CheckoutViewBody({super.key, required this.cart});

  final CartEntity cart;

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderCreated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const OrderSuccessView()),
          );
        }
        if (state is OrderError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: CartAppBar(title: 'Checkout')),
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
                        value: loaded.selectedPaymentMethod == null
                            ? 'Add Payment Method'
                            : '**** ${loaded.selectedPaymentMethod!.last4}',
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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

  // ------------------------------------------------------------
  // PLACE ORDER
  // ------------------------------------------------------------

  Widget _buildPlaceOrderButton(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, checkoutState) {
        final loaded = checkoutState is CheckoutLoaded ? checkoutState : null;
        final canPlaceOrder =
            loaded?.selectedAddress != null &&
            loaded?.selectedPaymentMethod != null;
        final total = cart.subtotal ?? 0.0;

        return BlocBuilder<OrderCubit, OrderState>(
          builder: (context, orderState) {
            final isPlacing = orderState is OrderLoading;

            return SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: canPlaceOrder && !isPlacing
                    ? () => _placeOrder(context, loaded!)
                    : null,
                style: FilledButton.styleFrom(
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: isPlacing
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

  void _placeOrder(BuildContext context, CheckoutLoaded state) {
    final address = state.selectedAddress;
    final paymentMethod = state.selectedPaymentMethod;
    if (address == null || paymentMethod == null) return;

    final products = cart.items
        .map(
          (item) => {
            'product': item.productId,
            'variant': item.variantId,
            'quantity': item.quantity,
            if (item.price != null) 'price': item.price,
          },
        )
        .toList();

    context.read<OrderCubit>().createOrder(
      products: products,
      totalPrice: cart.subtotal ?? 0.0,
      shippingAddress: {
        'street': address.street,
        'city': address.city,
        'country': address.country,
        'postalCode': address.postalCode,
      },
      paymentMethod: paymentMethod.brand,
    );
  }

  // ------------------------------------------------------------
  // PICKERS
  // ------------------------------------------------------------

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
                  // TODO: push add-address flow, then cubit.init() on return.
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
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.paymentMethods.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No saved payment methods yet.'),
                ),
              for (final method in state.paymentMethods)
                ListTile(
                  title: Text('**** ${method.last4}'),
                  trailing: method.id == state.selectedPaymentMethod?.id
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    cubit.selectPaymentMethod(method);
                    Navigator.of(sheetContext).pop();
                  },
                ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Add New Payment Method'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  // TODO: push add-payment flow, then cubit.init() on return.
                },
              ),
            ],
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
