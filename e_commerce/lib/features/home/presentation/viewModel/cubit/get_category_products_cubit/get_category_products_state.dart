
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';

enum CategoryProductsStatus { initial, loading, loaded, loadingMore, error }

abstract class GetCategoryProductsState {
  const GetCategoryProductsState();
}

class GetCategoryProductsInitial extends GetCategoryProductsState {
  const GetCategoryProductsInitial();
}

class GetCategoryProductsLoading extends GetCategoryProductsState {
  const GetCategoryProductsLoading();
}

class GetCategoryProductsSuccess extends GetCategoryProductsState {
  final List<ProductEntity> products;
  final int currentPage;
  final bool hasReachedMax;
  final CategoryProductsStatus status;

  const GetCategoryProductsSuccess({
    required this.products,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.status = CategoryProductsStatus.loaded,
  });
}

class GetCategoryProductsError extends GetCategoryProductsState {
  final String message;

  const GetCategoryProductsError(this.message);
}
