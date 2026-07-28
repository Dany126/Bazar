import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/features/home/domain/usecases/get_products_by_category_usecase.dart';
import 'get_category_products_state.dart';

class CategoryProductsCubit extends Cubit<GetCategoryProductsState> {
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;
  final String categoryId;

  static const int _limit = 10;

  CategoryProductsCubit({
    required this.getProductsByCategoryUseCase,
    required this.categoryId,
  }) : super(const GetCategoryProductsInitial());

  Future<void> fetchProducts() async {
    emit(const GetCategoryProductsLoading());

    final result = await getProductsByCategoryUseCase(
      GetProductsByCategoryParams(
        categoryId: categoryId,
        page: 1,
        limit: _limit,
      ),
    );

    result.fold(
      (failure) {
        emit(GetCategoryProductsError(failure.message));
      },
      (products) {
        emit(
          GetCategoryProductsSuccess(
            products: products,
            currentPage: 1,
            hasReachedMax: products.length < _limit,
          ),
        );
      },
    );
  }

  Future<void> fetchMoreProducts() async {
    if (state is! GetCategoryProductsSuccess) return;

    final currentState = state as GetCategoryProductsSuccess;

    if (currentState.hasReachedMax ||
        currentState.status == CategoryProductsStatus.loadingMore) {
      return;
    }

    emit(
      GetCategoryProductsSuccess(
        products: currentState.products,
        currentPage: currentState.currentPage,
        hasReachedMax: currentState.hasReachedMax,
        status: CategoryProductsStatus.loadingMore,
      ),
    );

    final nextPage = currentState.currentPage + 1;

    final result = await getProductsByCategoryUseCase(
      GetProductsByCategoryParams(
        categoryId: categoryId,
        page: nextPage,
        limit: _limit,
      ),
    );

    result.fold(
      (failure) {
        emit(GetCategoryProductsError(failure.message));
      },
      (newProducts) {
        emit(
          GetCategoryProductsSuccess(
            products: [...currentState.products, ...newProducts],
            currentPage: nextPage,
            hasReachedMax: newProducts.length < _limit,
            status: CategoryProductsStatus.loaded,
          ),
        );
      },
    );
  }

  Future<void> refresh() async {
    await fetchProducts();
  }
}
