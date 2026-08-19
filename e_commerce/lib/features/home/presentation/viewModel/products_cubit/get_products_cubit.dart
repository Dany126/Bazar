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

  Future<Either<Failure, List<ProductEntity>>> fetchAllProducts({
    required int page,
    required int limit,
  }) async {
    emit(GetProductsLoading());
    try {
      final result = await getAllProductsUseCase.call(page: page, limit: limit);
      result.fold(
        (failure) => emit(GetProductsFailure(message: failure.toString())),
        (products) => emit(GetProductsSuccess(products: products)),
      );
      return result;
    } catch (e) {
      emit(GetProductsFailure(message: e.toString()));
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<ProductEntity>>> fetchBestSellingProducts({
    required int page,
    required int limit,
  }) async {
    emit(GetProductsLoading());
    try {
      final result = await getBestSellingProductsUseCase.call(
        page: page,
        limit: limit,
      );
      result.fold(
        (failure) => emit(GetProductsFailure(message: failure.toString())),
        (products) => emit(GetProductsSuccess(products: products)),
      );

      return result;
    } catch (e) {
      emit(GetProductsFailure(message: e.toString()));
      return Left(ServerFailure(message: e.toString()));
    }
  }

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
        (failure) => emit(GetProductsFailure(message: failure.toString())),
        (products) => emit(GetProductsSuccess(products: products)),
      );
      return result;
    } catch (e) {
      emit(GetProductsFailure(message: e.toString()));
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// Toggles favourite status. On success, updates the currently held
  /// list in place — removing the item outright when `isFavourite` is
  /// false (the favorites screen listens for exactly this), or just
  /// flipping the flag otherwise. No refetch, no GetProductsLoading.
  Future<Either<Failure, Unit>> changeToIsFavourite({
    required String productId,
    required bool isFavourite,
  }) async {
    try {
      final result = await changeToIsFavouriteUseCase.call(
        productId: productId,
        isFavourite: isFavourite,
      );
      result.fold(
        (failure) => emit(GetProductsFailure(message: failure.toString())),
        (_) {
          final currentProducts = state is GetProductsSuccess
              ? (state as GetProductsSuccess).products
              : const <ProductEntity>[];

          final updatedProducts = !isFavourite
              ? currentProducts.where((p) => p.id != productId).toList()
              : currentProducts
                    .map(
                      (p) => p.id == productId
                          ? ProductEntity(
                              id: p.id,
                              name: p.name,

                              thumbnailUrl: p.thumbnailUrl,

                              category: p.category,

                              price: p.price,

                              rating: p.rating,
                              stock: p.stock,
                              soldCount: p.soldCount,
                              ratingsQuantity: p.ratingsQuantity,
                              isFavorite: isFavourite,
                            )
                          : p,
                    )
                    .toList();

          emit(
            ProductFavouriteChanged(
              products: updatedProducts,
              productId: productId,
              isFavourite: isFavourite,
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

  Future<Either<Failure, List<ProductEntity>>> fetchNewProducts({
    required int page,
    required int limit,
  }) async {
    emit(GetProductsLoading());
    try {
      final result = await getNewestProductsUseCase.call(
        page: page,
        limit: limit,
      );
      result.fold(
        (failure) => emit(GetProductsFailure(message: failure.toString())),
        (products) => emit(GetProductsSuccess(products: products)),
      );

      return result;
    } catch (e) {
      emit(GetProductsFailure(message: e.toString()));
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<ProductEntity>>> fetchAllProductsByCategories({
    required int page,
    required int limit,
    required String categoryId,
  }) async {
    emit(GetProductsLoading());
    try {
      final result = await getAllProductsByCategoriesUseCase.call(
        page: page,
        limit: limit,
        categoryId: categoryId,
      );
      result.fold(
        (failure) => emit(GetProductsFailure(message: failure.toString())),
        (products) => emit(GetProductsSuccess(products: products)),
      );
      return result;
    } catch (e) {
      emit(GetProductsFailure(message: e.toString()));
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
