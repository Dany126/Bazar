import 'package:e_commerce/features/home/domain/entity/category_entity.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';

abstract class HomeStates {}

class HomeInitial extends HomeStates {}

class HomeLoading extends HomeStates {}

class HomeLoaded extends HomeStates {
  final List<CategoryEntity> categories;
  final List<ProductEntity> bestSellingProducts;
  final List<ProductEntity> newProducts;

  HomeLoaded({
    required this.categories,
    required this.bestSellingProducts,
    required this.newProducts,
  });
}

class HomeError extends HomeStates {
  final String message;

  HomeError({required this.message});
}
