import 'package:e_commerce/features/home/data/models/product_model.dart';

abstract class AdminProductsState {
  const AdminProductsState();
}

class AdminProductsInitial extends AdminProductsState {}

class AdminProductsLoading extends AdminProductsState {}

class AdminProductsLoaded extends AdminProductsState {
  final List<ProductModel> products;
  const AdminProductsLoaded(this.products);
}

class AdminProductsFailure extends AdminProductsState {
  final String message;
  const AdminProductsFailure(this.message);
}

// Emitted transiently after a successful create/update/delete
// so the view can show a snackbar, then the cubit reloads the list.
class AdminProductActionSuccess extends AdminProductsState {
  final String message;
  final List<ProductModel> products;
  const AdminProductActionSuccess(this.message, this.products);
}