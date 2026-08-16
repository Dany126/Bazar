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
                      _buildAppBar(context),

                      const SizedBox(height: 8),

                      _buildRemoveAll(context, horizontalPadding),

                      const SizedBox(height: 8),

                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: cart.items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = cart.items[index];

                            return CartItemCard(
                              item: item,

                              onIncrement: () {
                                context
                                    .read<CartCubit>()
                                    .updateCartItemQuantity(
                                      itemId: item.id,
                                      quantity: item.quantity + 1,
                                    );
                              },

                              onDecrement: item.quantity > 1
                                  ? () {
                                      context
                                          .read<CartCubit>()
                                          .updateCartItemQuantity(
                                            itemId: item.id,
                                            quantity: item.quantity - 1,
                                          );
                                    }
                                  : null,

                              onRemove: () {
                                context.read<CartCubit>().removeFromCart(
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

                      _buildCheckoutButton(context, horizontalPadding),

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

  // ------------------------------------------------------------
  // APP BAR
  // ------------------------------------------------------------

  Widget _buildAppBar(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          _buildBackButton(context),

          const Spacer(),

          Text('Cart', style: AppStyles.textStylesSemiBold20(context)),

          const Spacer(),

          const SizedBox(width: 42),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BACK BUTTON
  // ------------------------------------------------------------

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(10),
        child: Transform.rotate(
          angle: 3.1415926535,
          child: Image.asset(
            Assets.assetsImagesArrowright,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // REMOVE ALL
  // ------------------------------------------------------------

  Widget _buildRemoveAll(BuildContext context, double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding > 16 ? 4 : 0),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {
            context.read<CartCubit>().removeAllFromCartUseCase();
          },
          child: Text(
            'Remove All',
            style: AppStyles.textStylesSemiBold15(
              context,
            ).copyWith(color: Colors.black87),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // CHECKOUT BUTTON
  // ------------------------------------------------------------

  Widget _buildCheckoutButton(BuildContext context, double horizontalPadding) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const CheckoutView()));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kPrimaryAccentColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Text(
          'Checkout',
          style: AppStyles.textStylesSemiBold15(
            context,
          ).copyWith(color: Colors.white),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // ERROR
  // ------------------------------------------------------------

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red.shade400),

            const SizedBox(height: 16),

            Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.textStylesRegular16(context),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                context.read<CartCubit>().getCart();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
