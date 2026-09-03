import 'package:e_commerce/features/home/data/models/product_model.dart';

abstract class AdminProductsState {
  const AdminProductsState();
}

class AdminProductsInitial extends AdminProductsState {
  const AdminProductsInitial();
}

class AdminProductsLoading extends AdminProductsState {
  const AdminProductsLoading();
}

class AdminProductsLoaded extends AdminProductsState {
  final List<ProductModel> products;

  const AdminProductsLoaded(this.products);
}

class AdminProductsFailure extends AdminProductsState {
  final String message;

  const AdminProductsFailure(this.message);
}

class AdminProductActionSuccess extends AdminProductsState {
  final String message;
  final List<ProductModel> products;

  const AdminProductActionSuccess(this.message, this.products);
}
