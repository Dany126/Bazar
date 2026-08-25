// lib/features/cart/presenation/view/widgets/cart_view_body.dart

import 'dart:developer';

import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_state.dart';
import 'package:e_commerce/core/widgets/custom_app_bar.dart';
import 'package:e_commerce/features/cart/presentation/view/widgets/cart_checkout_button.dart';
import 'package:e_commerce/features/cart/presentation/view/widgets/cart_empty_state.dart';
import 'package:e_commerce/features/cart/presentation/view/widgets/cart_error_state.dart';
import 'package:e_commerce/features/cart/presentation/view/widgets/cart_item_card.dart';
import 'package:e_commerce/features/cart/presentation/view/widgets/cart_remove_all.dart';
import 'package:e_commerce/features/cart/presentation/view/widgets/cart_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoading || state is CartInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CartError) {
          return CartErrorState(message: state.message);
        }

        if (state is CartLoaded) {
          if (state.cart.items.isEmpty) {
            return const CartEmptyState();
          }

          final cart = state.cart;

          log(cart.toString());

          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                final horizontalPadding = width < 360
                    ? 12.0
                    : width < 600
                    ? 16.0
                    : 24.0;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomAppBar(title: 'Cart'),

                      const SizedBox(height: 8),

                      CartRemoveAll(horizontalPadding: horizontalPadding),

                      const SizedBox(height: 8),

                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: cart.items.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = cart.items[index];

                            return CartItemCard(
                              item: item,

                              onIncrement: () {
                                context
                                    .read<CartCubit>()
                                    .updateCartItemQuantity(
                                      variantId: item.variantId,

                                      itemId: item.id,
                                      quantity: item.quantity + 1,
                                    );
                              },

                              onDecrement: item.quantity > 1
                                  ? () {
                                      context
                                          .read<CartCubit>()
                                          .updateCartItemQuantity(
                                            variantId: item.variantId,
                                            itemId: item.id,
                                            quantity: item.quantity - 1,
                                          );
                                    }
                                  : null,

                              onRemove: () {
                                context.read<CartCubit>().removeFromCart(
                                  variantId: item.variantId,
                                  itemId: item.id,
                                );
                              },
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 8),

                      CartSummary(cart: cart),

                      const SizedBox(height: 8),

                      CartCheckoutButton(cart: cart),

                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
