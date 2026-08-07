import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/domain/usecases/get_all_products_by_categories_use_case.dart';
import 'package:e_commerce/features/home/domain/usecases/get_all_products_usecase.dart';
import 'package:e_commerce/features/home/domain/usecases/get_best_selling_product_use_case.dart';
import 'package:e_commerce/features/home/domain/usecases/get_newest_product_use_case.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetProductsCubit extends Cubit<GetProductsState> {
  GetProductsCubit({
    required this.getAllProductsUseCase,
    required this.getAllProductsByCategoriesUseCase,
    required this.getBestSellingProductsUseCase,
    required this.getNewestProductsUseCase,
  }) : super(GetProductsInitial());

  final GetAllProductsUseCase getAllProductsUseCase;
  final GetAllProductsByCategoriesUseCase getAllProductsByCategoriesUseCase;
  final GetBestSellingProductUseCase getBestSellingProductsUseCase;
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
