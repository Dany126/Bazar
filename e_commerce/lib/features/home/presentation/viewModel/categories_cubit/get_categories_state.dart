import 'package:e_commerce/features/home/domain/entity/category_entity.dart';

abstract class GetCategoriesState {}

class GetCategoriesInitial extends GetCategoriesState {}

class GetCategoriesLoading extends GetCategoriesState {}

class GetCategoriesSuccess extends GetCategoriesState {
  final List<CategoryEntity> categories;

  GetCategoriesSuccess(this.categories);
}

class GetCategoriesFailure extends GetCategoriesState {
  final String message;

  GetCategoriesFailure(this.message);
}

