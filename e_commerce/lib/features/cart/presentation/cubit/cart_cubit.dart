// lib/features/cart/presenation/modelview/cubit/cart_cubit.dart

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

  Future<void> getCart() async {
    emit(CartLoading());
    final result = await getCartUseCase();
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> addToCart({
    required String productId,
    String? size,
    String? color,
    required int quantity,
  }) async {
    final result = await addToCartUseCase(
      productId: productId,
      size: size,
      color: color,
      quantity: quantity,
    );
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> updateCartItemQuantity({
    required String itemId,
    required int quantity,
  }) async {
    final result = await updateCartItemQuantityUseCase(
      itemId: itemId,
      quantity: quantity,
    );
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> removeFromCart({required String itemId}) async {
    final result = await removeFromCartUseCase(itemId: itemId);
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> removeAllFromCart() async {
    final result = await removeAllFromCartUseCase();
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> applyCoupon({required String code}) async {
    final result = await applyCouponUseCase(code: code);
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) => emit(CartLoaded(cart)),
    );
  }
}
