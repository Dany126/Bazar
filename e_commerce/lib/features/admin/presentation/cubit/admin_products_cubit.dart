import 'package:e_commerce/features/admin/data/models/admin_product_variant_model.dart';
import 'package:e_commerce/features/admin/domain/usecases/create_admin_product.dart';
import 'package:e_commerce/features/admin/domain/usecases/create_admin_variant.dart';
import 'package:e_commerce/features/admin/domain/usecases/delete_admin_product.dart';
import 'package:e_commerce/features/admin/domain/usecases/delete_admin_variant.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_admin_variants.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_all_admin_products.dart';
import 'package:e_commerce/features/admin/domain/usecases/update_admin_product.dart';
import 'package:e_commerce/features/admin/domain/usecases/update_admin_variant.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_products_state.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AdminProductsCubit extends Cubit<AdminProductsState> {
  final GetAllAdminProductsUseCase getAllProductsUseCase;
  final CreateAdminProductUseCase createProductUseCase;
  final UpdateAdminProductUseCase updateProductUseCase;
  final DeleteAdminProductUseCase deleteProductUseCase;

  final CreateAdminVariantUseCase createVariantUseCase;
  final GetAdminVariantsUseCase getVariantsUseCase;
  final UpdateAdminVariantUseCase updateVariantUseCase;
  final DeleteAdminVariantUseCase deleteVariantUseCase;

  AdminProductsCubit({
    required this.getAllProductsUseCase,
    required this.createProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
    required this.createVariantUseCase,
    required this.getVariantsUseCase,
    required this.updateVariantUseCase,
    required this.deleteVariantUseCase,
  }) : super(const AdminProductsInitial());

  // ============================================================
  // LOAD PRODUCTS
  // ============================================================

  Future<void> loadProducts() async {
    emit(const AdminProductsLoading());

    final result = await getAllProductsUseCase();

    result.fold(
      (failure) {
        emit(AdminProductsFailure(failure.message));
      },
      (products) {
        // IMPORTANT:
        // [] is a successful response.
        //
        // We MUST emit Loaded([]), not Failure.
        emit(AdminProductsLoaded(products));
      },
    );
  }

  // ============================================================
  // CREATE PRODUCT
  // ============================================================

  Future<ProductModel?> createProduct({
    required String name,
    required String categoryId,
    required double price,
    required List<XFile> images,
  }) async {
    emit(const AdminProductsLoading());

    final result = await createProductUseCase(
      name: name,
      categoryId: categoryId,
      price: price,
      images: images,
    );

    return result.fold(
      (failure) {
        emit(AdminProductsFailure(failure.message));

        return null;
      },
      (product) {
        return product;
      },
    );
  }

  // ============================================================
  // UPDATE PRODUCT
  // ============================================================

  Future<bool> updateProduct({
    required String id,
    String? name,
    String? categoryId,
    double? price,
    List<XFile>? images,
  }) async {
    final result = await updateProductUseCase(
      id: id,
      name: name,
      categoryId: categoryId,
      price: price,
      images: images,
    );

    return result.fold(
      (failure) {
        emit(AdminProductsFailure(failure.message));

        return false;
      },
      (_) async {
        await loadProducts();

        return true;
      },
    );
  }
  // ============================================================
  // DELETE PRODUCT
  // ============================================================

  Future<bool> deleteProduct(String id) async {
    final result = await deleteProductUseCase(id);

    return result.fold(
      (failure) {
        emit(AdminProductsFailure(failure.message));

        return false;
      },
      (_) async {
        await loadProducts();
        return true;
      },
    );
  }

  // ============================================================
  // CREATE VARIANT
  // ============================================================

  Future<String?> createVariant({
    required String productId,
    required String size,
    required String color,
    required double price,
    required int stock,
  }) async {
    final result = await createVariantUseCase(
      productId: productId,
      size: size,
      color: color,
      price: price,
      stock: stock,
    );

    return result.fold((failure) => failure.message, (_) => null);
  }

  // ============================================================
  // GET VARIANTS
  // ============================================================

  Future<List<AdminProductVariantModel>> getVariants(String productId) async {
    final result = await getVariantsUseCase(productId);

    return result.fold(
      (failure) {
        return <AdminProductVariantModel>[];
      },
      (variants) {
        return variants;
      },
    );
  }

  // ============================================================
  // UPDATE VARIANT
  // ============================================================

  Future<String?> updateVariant({
    required String id,
    String? size,
    String? color,
    double? price,
    int? stock,
  }) async {
    final result = await updateVariantUseCase(
      id: id,
      size: size,
      color: color,
      price: price,
      stock: stock,
    );

    return result.fold((failure) => failure.message, (_) => null);
  }

  // ============================================================
  // DELETE VARIANT
  // ============================================================

  Future<String?> deleteVariant(String id) async {
    final result = await deleteVariantUseCase(id);

    return result.fold((failure) => failure.message, (_) => null);
  }
}
