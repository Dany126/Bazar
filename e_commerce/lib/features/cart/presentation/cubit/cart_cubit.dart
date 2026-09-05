// lib/features/cart/presentation/cubit/cart_cubit.dart

import 'dart:developer';

import 'package:e_commerce/features/cart/data/model/cart_model.dart';
import 'package:e_commerce/features/cart/domain/use_case/add_to_cart_use_case.dart';
import 'package:e_commerce/features/cart/domain/use_case/apply_coupon_use_case.dart';
import 'package:e_commerce/features/cart/domain/use_case/get_cart_use_case.dart';
import 'package:e_commerce/features/cart/domain/use_case/remove_all_from_cart_use_case.dart';
import 'package:e_commerce/features/cart/domain/use_case/remove_from_cart_use_case.dart';
import 'package:e_commerce/features/cart/domain/use_case/update_cart_item_quantity_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartItemQuantityUseCase updateCartItemQuantityUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final RemoveAllFromCartUseCase removeAllFromCartUseCase;
  final ApplyCouponUseCase applyCouponUseCase;

  CartCubit({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.updateCartItemQuantityUseCase,
    required this.removeFromCartUseCase,
    required this.removeAllFromCartUseCase,
    required this.applyCouponUseCase,
  }) : super(CartInitial());

  // ============================================================
  // GET CART
  // ============================================================

  Future<void> getCart() async {
    emit(CartLoading());

    final result = await getCartUseCase();

    result.fold(
      (failure) {
        /*
         * The backend returns:
         *
         * 400
         * {
         *   "status": "Failed",
         *   "message": "No cart found"
         * }
         *
         * This does NOT mean that loading the cart failed.
         * It simply means that this user has never created a cart.
         *
         * Treat it as an empty cart so the UI can show:
         * "Your cart is empty"
         *
         * instead of:
         * "No cart found"
         */
        if (_isNoCartError(failure.message)) {
          log('No cart found. Treating cart as empty.');

          emit(CartLoaded(CartModel(id: '', userId: '', items: [])));

          return;
        }

        emit(CartError(failure.message));
      },
      (cart) {
        emit(CartLoaded(cart));
      },
    );
  }

  // ============================================================
  // ADD TO CART
  // ============================================================

  Future<void> addToCart({
    required String productId,
    required String variantId,
    required int quantity,
  }) async {
    log('Adding product to cart');
    log('Product ID: $productId');
    log('Variant ID: $variantId');
    log('Quantity: $quantity');

    final result = await addToCartUseCase(
      productId: productId,
      variantId: variantId,
      quantity: quantity,
    );

    result.fold(
      (failure) {
        emit(CartError(failure.message));
      },
      (cart) {
        emit(CartLoaded(cart));
      },
    );
  }

  // ============================================================
  // UPDATE CART ITEM QUANTITY
  // ============================================================

  Future<void> updateCartItemQuantity({
    required String itemId,
    required String variantId,
    required int quantity,
  }) async {
    final result = await updateCartItemQuantityUseCase(
      itemId: itemId,
      quantity: quantity,
      variantId: variantId,
    );

    result.fold(
      (failure) {
        emit(CartError(failure.message));
      },
      (cart) {
        emit(CartLoaded(cart));
      },
    );
  }

  // ============================================================
  // REMOVE FROM CART
  // ============================================================

  Future<void> removeFromCart({
    required String itemId,
    required String variantId,
  }) async {
    final result = await removeFromCartUseCase(
      itemId: itemId,
      variantId: variantId,
    );

    result.fold(
      (failure) {
        /*
         * If the cart no longer exists, the correct UI state
         * is also an empty cart.
         */
        if (_isNoCartError(failure.message)) {
          emit(CartLoaded(CartModel(id: '', userId: '', items: [])));

          return;
        }

        emit(CartError(failure.message));
      },
      (cart) {
        emit(CartLoaded(cart));
      },
    );
  }

  // ============================================================
  // REMOVE ALL FROM CART
  // ============================================================

  Future<void> removeAllFromCart() async {
    final result = await removeAllFromCartUseCase();

    result.fold(
      (failure) {
        if (_isNoCartError(failure.message)) {
          emit(CartLoaded(CartModel(id: '', userId: '', items: [])));

          return;
        }

        emit(CartError(failure.message));
      },
      (cart) {
        emit(CartLoaded(cart));
      },
    );
  }

  // ============================================================
  // APPLY COUPON
  // ============================================================

  Future<void> applyCoupon({required String code}) async {
    final result = await applyCouponUseCase(code: code);

    result.fold(
      (failure) {
        emit(CartError(failure.message));
      },
      (cart) {
        emit(CartLoaded(cart));
      },
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  bool _isNoCartError(String? message) {
    if (message == null) return false;

    final normalized = message.toLowerCase().trim();

    return normalized.contains('no cart found') ||
        normalized.contains('cart not found') ||
        normalized.contains('cart does not exist');
  }
}
