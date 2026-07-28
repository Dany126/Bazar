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

    final results = await Future.wait([
      getCategoriesUseCase(NoParams()),
      getBestSellingProductsUseCase(const GetBestSellingProductsParams()),
      getNewProductsUseCase(const GetNewProductsParams()),
    ]);

    final categoriesResult = results[0];
    final bestSellingResult = results[1];
    final newProductsResult = results[2];

    String? error;

    categoriesResult.fold((f) => error = f.message, (_) {});
    bestSellingResult.fold((f) => error ??= f.message, (_) {});
    newProductsResult.fold((f) => error ??= f.message, (_) {});

    if (error != null) {
      emit(HomeError(message: error!));
      return;
    }

    emit(
      HomeLoaded(
        categories:
            categoriesResult.getOrElse(() => []) as List<CategoryEntity>,
        bestSellingProducts:
            bestSellingResult.getOrElse(() => []) as List<ProductEntity>,
        newProducts:
            newProductsResult.getOrElse(() => []) as List<ProductEntity>,
      ),
    );
  }

  Future<void> refresh() => fetchHomeData();
}
