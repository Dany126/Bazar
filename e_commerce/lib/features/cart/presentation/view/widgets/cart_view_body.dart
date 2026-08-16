// lib/features/cart/presenation/view/widgets/cart_view_body.dart

import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_state.dart';
import 'package:e_commerce/features/cart/presentation/view/widgets/cart_empty_state.dart';
import 'package:e_commerce/features/cart/presentation/view/widgets/cart_item_card.dart';
import 'package:e_commerce/features/cart/presentation/view/widgets/cart_summary.dart';
import 'package:e_commerce/features/checkout/presentation/views/checkout_view.dart';
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
          return _buildErrorState(context, state.message);
        }

        if (state is CartLoaded) {
          if (state.cart.items.isEmpty) {
            return const CartEmptyState();
          }

          final cart = state.cart;

          return Column(
            children: [
              _buildAppBar(context, cart.items.isNotEmpty),
              const SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Visibility(
                  visible: cart.items.isNotEmpty,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => context
                            .read<CartCubit>()
                            .removeAllFromCartUseCase(),
                        child: Text(
                          "Remove All",
                          style: AppStyles.textStylesSemiBold15(
                            context,
                          ).copyWith(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return CartItemCard(
                      item: item,
                      onIncrement: () =>
                          context.read<CartCubit>().updateCartItemQuantity(
                            itemId: item.id,
                            quantity: item.quantity + 1,
                          ),
                      onDecrement: item.quantity > 1
                          ? () => context
                                .read<CartCubit>()
                                .updateCartItemQuantity(
                                  itemId: item.id,
                                  quantity: item.quantity - 1,
                                )
                          : null,
                      onRemove: () => context.read<CartCubit>().removeFromCart(
                        itemId: item.id,
                      ),
                    );
                  },
                ),
              ),
              CartSummary(cart: cart),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CheckoutView()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kPrimaryAccentColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildAppBar(BuildContext context, bool hasItems) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.rotate(
            angle: 3.14, // Rotation angle in radians
            child: CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: Image.asset(Assets.assetsImagesArrowright),
            ),
          ),
          Spacer(flex: 3),

          Text(
            textAlign: TextAlign.center,

            'Cart',
            style: AppStyles.textStylesSemiBold20(context),
          ),
          Spacer(flex: 4),
        ],
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
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<CartCubit>().getCart(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
