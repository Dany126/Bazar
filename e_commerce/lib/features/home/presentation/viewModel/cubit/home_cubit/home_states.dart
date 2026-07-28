import 'package:e_commerce/features/home/domain/entity/category_entity.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CategoryEntity> categories;
  final List<ProductEntity> bestSellingProducts;
  final List<ProductEntity> newProducts;

  HomeLoaded({
    required this.categories,
    required this.bestSellingProducts,
    required this.newProducts,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}
