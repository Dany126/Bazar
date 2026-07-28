import 'dart:developer';

import 'package:e_commerce/core/use_case/use_case.dart';
import 'package:e_commerce/features/home/domain/entity/category_entity.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/domain/usecases/get_best_selling_products_usecase.dart';
import 'package:e_commerce/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:e_commerce/features/home/domain/usecases/get_new_products_usecase.dart';
import 'package:e_commerce/features/home/presentation/viewModel/cubit/home_cubit/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetBestSellingProductsUseCase getBestSellingProductsUseCase;
  final GetNewProductsUseCase getNewProductsUseCase;

  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getBestSellingProductsUseCase,
    required this.getNewProductsUseCase,
  }) : super(HomeInitial());

  Future<void> fetchHomeData() async {
    emit(HomeLoading());

    try {
      final categoriesFuture = getCategoriesUseCase(NoParams());
      log(categoriesFuture as String);
      final bestSellingFuture = getBestSellingProductsUseCase(
        const GetBestSellingProductsParams(),
      );
      final newProductsFuture = getNewProductsUseCase(
        const GetNewProductsParams(),
      );

      final categoriesResult = await categoriesFuture;
      final bestSellingResult = await bestSellingFuture;
      final newProductsResult = await newProductsFuture;

      String? error;

      categoriesResult.fold((failure) => error = failure.message, (_) {});

      bestSellingResult.fold((failure) => error ??= failure.message, (_) {});

      newProductsResult.fold((failure) => error ??= failure.message, (_) {});

      if (error != null) {
        emit(HomeError(message: error!));
        return;
      }

      final categories = categoriesResult.getOrElse(() => <CategoryEntity>[]);
      log(categories as String);

      final bestSellingProducts = bestSellingResult.getOrElse(
        () => <ProductEntity>[],
      );
      log(bestSellingProducts as String);

      final newProducts = newProductsResult.getOrElse(() => <ProductEntity>[]);
      log(newProducts as String);

      emit(
        HomeLoaded(
          categories: categories,
          bestSellingProducts: bestSellingProducts,
          newProducts: newProducts,
        ),
      );
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> refresh() async {
    await fetchHomeData();
  }
}
