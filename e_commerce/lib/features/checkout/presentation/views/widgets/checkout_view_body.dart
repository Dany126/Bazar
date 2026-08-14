// lib/features/checkout/presenation/view/widgets/checkout_view_body.dart

import 'package:e_commerce/features/address/domain/entity/address_entity.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_cubit.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_state.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_state.dart';
import 'package:e_commerce/features/checkout/presentation/views/widgets/checkout_selection_row.dart';
import 'package:e_commerce/features/checkout/presentation/views/widgets/checkout_summary.dart';

import 'package:e_commerce/features/order/presenation/modelview/cubit/order_cubit.dart';
import 'package:e_commerce/features/order/presenation/modelview/cubit/order_state.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/order_success_view.dart';
import 'package:e_commerce/features/payment_method/domain/entity/payment_method_entity.dart';
import 'package:e_commerce/features/payment_method/presentation/model_view/cubit/payment_method_cubit.dart';
import 'package:e_commerce/features/payment_method/presentation/model_view/cubit/payment_method_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const kCheckoutAccentColor = Color(0xFF7B61FF);

class CheckoutViewBody extends StatefulWidget {
  const CheckoutViewBody({super.key});

  @override
  State<CheckoutViewBody> createState() => _CheckoutViewBodyState();
}

class _CheckoutViewBodyState extends State<CheckoutViewBody> {
  AddressEntity? selectedAddress;
  PaymentMethodEntity? selectedPaymentMethod;

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
      child: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  BlocBuilder<AddressCubit, AddressState>(
                    builder: (context, state) {
                      final addresses = state is AddressLoaded
                          ? state.addresses
                          : <AddressEntity>[];
                      selectedAddress ??= addresses.isNotEmpty
                          ? addresses.firstWhere(
                              (a) => a.isDefault,
                              orElse: () => addresses.first,
                            )
                          : null;

                      return CheckoutSelectionRow(
                        label: 'Shipping Address',
                        value: selectedAddress == null
                            ? null
                            : '${selectedAddress!.street}, ${selectedAddress!.city}',
                        placeholder: 'Add Shipping Address',
                        onTap: () {
                          // TODO: open address list / add-address screen,
                          // then setState(() => selectedAddress = picked);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<PaymentMethodCubit, PaymentMethodState>(
                    builder: (context, state) {
                      final methods = state is PaymentMethodLoaded
                          ? state.paymentMethods
                          : <PaymentMethodEntity>[];
                      selectedPaymentMethod ??= methods.isNotEmpty
                          ? methods.firstWhere(
                              (m) => m.isDefault,
                              orElse: () => methods.first,
                            )
                          : null;

                      return CheckoutSelectionRow(
                        label: 'Payment Method',
                        value: selectedPaymentMethod == null
                            ? null
                            : '**** ${selectedPaymentMethod!.last4}',
                        placeholder: 'Add Payment Method',
                        trailingDot: selectedPaymentMethod != null,
                        onTap: () {
                          // TODO: open payment method list / add screen,
                          // then setState(() => selectedPaymentMethod = picked);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      if (state is CartLoaded) {
                        return CheckoutSummary(cart: state.cart);
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
          _buildPlaceOrderBar(context),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[100],
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const Spacer(),
          const Text(
            'Checkout',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderBar(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        final total = cartState is CartLoaded ? cartState.cart.total : 0.0;
        final canPlaceOrder =
            selectedAddress != null && selectedPaymentMethod != null;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: BlocBuilder<OrderCubit, OrderState>(
              builder: (context, orderState) {
                final isPlacing = orderState is OrderLoading;

                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: canPlaceOrder && !isPlacing
                        ? () => _placeOrder(context, cartState)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kCheckoutAccentColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
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
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('\$${total.toStringAsFixed(0)}'),
                              const Text(
                                'Place Order',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 40),
                            ],
                          ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _placeOrder(BuildContext context, CartState cartState) {
    if (cartState is! CartLoaded || selectedAddress == null) return;

    final products = cartState.cart.items
        .map(
          (item) => {
            'product': item.productId,
            'quantity': item.quantity,
            'price': item.price,
            if (item.size != null) 'size': item.size,
            if (item.color != null) 'color': item.color,
          },
        )
        .toList();

    context.read<OrderCubit>().createOrder(
      products: products,
      totalPrice: cartState.cart.total,
      shippingAddress: {
        'street': selectedAddress!.street,
        'city': selectedAddress!.city,
        'country': selectedAddress!.country,
        'postalCode': selectedAddress!.postalCode,
      },
      paymentMethod: selectedPaymentMethod?.brand ?? 'cash',
    );
  }
}
