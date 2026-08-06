import 'package:e_commerce/features/home/domain/entity/product_entity.dart';

abstract class GetProductsState {}

class GetProductsInitial extends GetProductsState {}

class GetProductsLoading extends GetProductsState {}

class GetProductsSuccess extends GetProductsState {
  final List<ProductEntity> products;
  GetProductsSuccess({required this.products});
}

class GetProductsFailure extends GetProductsState {
  final String message;
  GetProductsFailure({required this.message});
}
