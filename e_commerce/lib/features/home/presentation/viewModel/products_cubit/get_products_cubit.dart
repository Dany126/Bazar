import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/domain/usecases/change_to_is_favourite.dart';
import 'package:e_commerce/features/home/domain/usecases/get_all_products_by_categories_use_case.dart';
import 'package:e_commerce/features/home/domain/usecases/get_all_products_usecase.dart';
import 'package:e_commerce/features/home/domain/usecases/get_best_selling_product_use_case.dart';
import 'package:e_commerce/features/home/domain/usecases/get_favourite_products_usecase.dart';
import 'package:e_commerce/features/home/domain/usecases/get_newest_product_use_case.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetProductsCubit extends Cubit<GetProductsState> {
  GetProductsCubit({
    required this.getFavoriteProductsUseCase,
    required this.getAllProductsUseCase,
    required this.getAllProductsByCategoriesUseCase,
    required this.getBestSellingProductsUseCase,
    required this.getNewestProductsUseCase,
    required this.changeToIsFavouriteUseCase,
  }) : super(GetProductsInitial());

  final ChangeToIsFavourite changeToIsFavouriteUseCase;
  final GetAllProductsUseCase getAllProductsUseCase;
  final GetAllProductsByCategoriesUseCase getAllProductsByCategoriesUseCase;
  final GetBestSellingProductUseCase getBestSellingProductsUseCase;
  final GetFavouriteProductsUseCase getFavoriteProductsUseCase;
  final GetNewtestProductUseCase getNewestProductsUseCase;

  /// Single source of truth for favourite products.
  ///
  /// key   = product id
  /// value = true if product is favourite
  static final ValueNotifier<Map<String, bool>> favoriteProductIds =
      ValueNotifier<Map<String, bool>>({});

  // ============================================================
  // LOAD FAVOURITES
  // ============================================================

  Future<Either<Failure, List<ProductEntity>>> loadFavouriteIds() async {
    try {
      final result = await getFavoriteProductsUseCase.call(
        page: 1,
        limit: 1000,
      );

      result.fold(
        (failure) {
          log('Failed to load favourites: ${failure.toString()}');
        },
        (products) {
          final Map<String, bool> favourites = {};

          for (final product in products) {
            favourites[product.id] = true;
          }

          favoriteProductIds.value = favourites;

          log(
            'Favourite IDs loaded: '
            '${favoriteProductIds.value.keys.toList()}',
          );
        },
      );

      return result;
    } catch (e) {
      log('loadFavouriteIds error: $e');

      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ============================================================
  // FETCH ALL PRODUCTS
  // ============================================================

  Future<Either<Failure, List<ProductEntity>>> fetchAllProducts({
    required int page,
    required int limit,
  }) async {
    emit(GetProductsLoading());

    try {
      // IMPORTANT:
      // Load favourite IDs BEFORE loading Home products.
      await loadFavouriteIds();

      final result = await getAllProductsUseCase.call(page: page, limit: limit);

      result.fold(
        (failure) {
          emit(GetProductsFailure(message: failure.toString()));
        },
        (products) {
          final updatedProducts = _applyFavouriteState(products);

          emit(GetProductsSuccess(products: updatedProducts));
        },
      );

      return result;
    } catch (e) {
      emit(GetProductsFailure(message: e.toString()));

      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ============================================================
  // APPLY FAVOURITE STATE
  // ============================================================

  List<ProductEntity> _applyFavouriteState(List<ProductEntity> products) {
    return products.map((product) {
      return ProductEntity(
        id: product.id,
        name: product.name,
        images: product.images,
        category: product.category,
        price: product.price,
        rating: product.rating,
        stock: product.stock,
        soldCount: product.soldCount,
        ratingsQuantity: product.ratingsQuantity,
        isFavorite: favoriteProductIds.value[product.id] ?? false,
      );
    }).toList();
  }

  // ============================================================
  // TOGGLE FAVOURITE
  // ============================================================

  Future<Either<Failure, Unit>> changeToIsFavourite({
    required String productId,
    required bool isFavourite,
  }) async {
    try {
      final result = await changeToIsFavouriteUseCase.call(
        productId: productId,
        isFavourite: isFavourite,
      );

      return await result.fold(
        (failure) {
          emit(GetProductsFailure(message: failure.toString()));

          return Left(failure);
        },
        (_) {
          // --------------------------------------------------
          // UPDATE GLOBAL FAVOURITE STATE
          // --------------------------------------------------

          final updatedMap = Map<String, bool>.from(favoriteProductIds.value);

          if (isFavourite) {
            updatedMap[productId] = true;
          } else {
            updatedMap.remove(productId);
          }

          favoriteProductIds.value = updatedMap;

          log(
            'Favourite changed: '
            '$productId -> $isFavourite',
          );

          // --------------------------------------------------
          // UPDATE CURRENT PRODUCTS
          // --------------------------------------------------

          if (state is GetProductsSuccess) {
            final currentProducts = (state as GetProductsSuccess).products;

            final updatedProducts = currentProducts.map((product) {
              if (product.id != productId) {
                return product;
              }

              return ProductEntity(
                id: product.id,
                name: product.name,
                images: product.images,
                category: product.category,
                price: product.price,
                rating: product.rating,
                stock: product.stock,
                soldCount: product.soldCount,
                ratingsQuantity: product.ratingsQuantity,
                isFavorite: isFavourite,
              );
            }).toList();

            emit(
              ProductFavouriteChanged(
                products: updatedProducts,
                productId: productId,
                isFavourite: isFavourite,
              ),
            );
          }

          return const Right(unit);
        },
      );
    } catch (e) {
      emit(GetProductsFailure(message: e.toString()));

      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ============================================================
  // BEST SELLING
  // ============================================================

  Future<Either<Failure, List<ProductEntity>>> fetchBestSellingProducts({
    required int page,
    required int limit,
  }) async {
    emit(GetProductsLoading());

    try {
      await loadFavouriteIds();

      final result = await getBestSellingProductsUseCase.call(
        page: page,
        limit: limit,
      );

      result.fold(
        (failure) {
          emit(GetProductsFailure(message: failure.toString()));
        },
        (products) {
          emit(GetProductsSuccess(products: _applyFavouriteState(products)));
        },
      );

      return result;
    } catch (e) {
      emit(GetProductsFailure(message: e.toString()));

      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ============================================================
  // NEW PRODUCTS
  // ============================================================

  Future<Either<Failure, List<ProductEntity>>> fetchNewProducts({
    required int page,
    required int limit,
  }) async {
    emit(GetProductsLoading());

    try {
      await loadFavouriteIds();

      final result = await getNewestProductsUseCase.call(
        page: page,
        limit: limit,
      );

      result.fold(
        (failure) {
          emit(GetProductsFailure(message: failure.toString()));
        },
        (products) {
          emit(GetProductsSuccess(products: _applyFavouriteState(products)));
        },
      );

      return result;
    } catch (e) {
      emit(GetProductsFailure(message: e.toString()));

      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ============================================================
  // CATEGORY PRODUCTS
  // ============================================================

  Future<Either<Failure, List<ProductEntity>>> fetchAllProductsByCategories({
    required int page,
    required int limit,
    required String categoryId,
  }) async {
    emit(GetProductsLoading());

    try {
      await loadFavouriteIds();

      final result = await getAllProductsByCategoriesUseCase.call(
        page: page,
        limit: limit,
        categoryId: categoryId,
      );

      result.fold(
        (failure) {
          emit(GetProductsFailure(message: failure.toString()));
        },
        (products) {
          emit(GetProductsSuccess(products: _applyFavouriteState(products)));
        },
      );

      return result;
    } catch (e) {
      emit(GetProductsFailure(message: e.toString()));

      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ============================================================
  // FAVOURITE PRODUCTS
  // ============================================================

  Future<Either<Failure, List<ProductEntity>>> fetchFavoriteProducts({
    required int page,
    required int limit,
  }) async {
    emit(GetProductsLoading());

    try {
      final result = await getFavoriteProductsUseCase.call(
        page: page,
        limit: limit,
      );

      result.fold(
        (failure) {
          emit(GetProductsFailure(message: failure.toString()));
        },
        (products) {
          // Make sure global state is updated.
          final updatedMap = Map<String, bool>.from(favoriteProductIds.value);

          for (final product in products) {
            updatedMap[product.id] = true;
          }

          favoriteProductIds.value = updatedMap;

          emit(
            GetProductsSuccess(
              products: products.map((product) {
                return ProductEntity(
                  id: product.id,
                  name: product.name,
                  images: product.images,
                  category: product.category,
                  price: product.price,
                  rating: product.rating,
                  stock: product.stock,
                  soldCount: product.soldCount,
                  ratingsQuantity: product.ratingsQuantity,
                  isFavorite: true,
                );
              }).toList(),
            ),
          );
        },
      );

      return result;
    } catch (e) {
      emit(GetProductsFailure(message: e.toString()));

      return Left(ServerFailure(message: e.toString()));
    }
  }
}
