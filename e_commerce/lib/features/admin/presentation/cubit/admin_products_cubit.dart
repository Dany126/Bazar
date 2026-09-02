import 'package:e_commerce/features/admin/domain/usecases/create_admin_product.dart';
import 'package:e_commerce/features/admin/domain/usecases/delete_admin_product.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_all_admin_products.dart';
import 'package:e_commerce/features/admin/domain/usecases/update_admin_product.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminProductsCubit extends Cubit<AdminProductsState> {
  final GetAllAdminProductsUseCase getAllProductsUseCase;
  final CreateAdminProductUseCase createProductUseCase;
  final UpdateAdminProductUseCase updateProductUseCase;
  final DeleteAdminProductUseCase deleteProductUseCase;

  AdminProductsCubit({
    required this.getAllProductsUseCase,
    required this.createProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  }) : super(AdminProductsInitial());

  Future<void> loadProducts() async {
    emit(AdminProductsLoading());
    final result = await getAllProductsUseCase();
    result.fold(
      (failure) => emit(AdminProductsFailure(failure.message)),
      (products) => emit(AdminProductsLoaded(products)),
    );
  }

  Future<void> createProduct({
    required String name,
    required String categoryId,
    required double price,
    required int stock,
    String? description,
    required List<String> imagePaths,
  }) async {
    final result = await createProductUseCase(
      name: name,
      categoryId: categoryId,
      price: price,
      stock: stock,
      description: description,
      imagePaths: imagePaths,
    );

    await result.fold(
      (failure) async => emit(AdminProductsFailure(failure.message)),
      (_) async => loadProducts(),
    );
  }

  Future<void> updateProduct({
    required String id,
    String? name,
    String? categoryId,
    double? price,
    int? stock,
    bool? isActive,
    String? description,
  }) async {
    final result = await updateProductUseCase(
      id: id,
      name: name,
      categoryId: categoryId,
      price: price,
      stock: stock,
      isActive: isActive,
      description: description,
    );

    await result.fold(
      (failure) async => emit(AdminProductsFailure(failure.message)),
      (_) async => loadProducts(),
    );
  }

  Future<void> deleteProduct(String id) async {
    final result = await deleteProductUseCase(id);

    await result.fold(
      (failure) async => emit(AdminProductsFailure(failure.message)),
      (_) async => loadProducts(),
    );
  }
}
