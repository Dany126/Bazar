import 'package:e_commerce/features/admin/domain/usecases/create_admin_category.dart';
import 'package:e_commerce/features/admin/domain/usecases/delete_admin_category.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_all_admin_categories.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_all_admin_products.dart';
import 'package:e_commerce/features/admin/domain/usecases/update_admin_category.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_state.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AdminCategoriesCubit extends Cubit<AdminCategoriesState> {
  final GetAllAdminCategoriesUseCase getAllAdminCategoriesUseCase;

  final CreateAdminCategoryUseCase createAdminCategoryUseCase;
  final UpdateAdminCategoryUseCase updateAdminCategoryUseCase;
  final DeleteAdminCategoryUseCase deleteAdminCategoryUseCase;

  final GetAllAdminProductsUseCase getAllAdminProductsUseCase;

  AdminCategoriesCubit({
    required this.getAllAdminCategoriesUseCase,
    required this.createAdminCategoryUseCase,
    required this.updateAdminCategoryUseCase,
    required this.deleteAdminCategoryUseCase,
    required this.getAllAdminProductsUseCase,
  }) : super(const AdminCategoriesInitial());

  // ============================================================
  // LOAD CATEGORIES + PRODUCTS
  // ============================================================

  Future<void> loadCategories() async {
    emit(const AdminCategoriesLoading());

    final categoriesResult = await getAllAdminCategoriesUseCase();

    if (categoriesResult.isLeft()) {
      categoriesResult.fold((failure) {
        emit(AdminCategoriesError(failure.message));
      }, (_) {});

      return;
    }

    final productsResult = await getAllAdminProductsUseCase();

    if (productsResult.isLeft()) {
      productsResult.fold((failure) {
        emit(AdminCategoriesError(failure.message));
      }, (_) {});

      return;
    }

    final categories = categoriesResult.getOrElse(() => <CategoryModel>[]);

    final products = productsResult.getOrElse(() => []);

    emit(AdminCategoriesLoaded(categories: categories, products: products));
  }

  // ============================================================
  // SELECT CATEGORY
  // ============================================================

  void selectCategory(CategoryModel category) {
    final currentState = state;

    if (currentState is! AdminCategoriesLoaded) {
      return;
    }

    emit(
      currentState.copyWith(
        selectedCategoryId: category.id,
        selectedCategoryName: category.name,
      ),
    );
  }

  // ============================================================
  // SHOW ALL PRODUCTS
  // ============================================================

  void showAllProducts() {
    final currentState = state;

    if (currentState is! AdminCategoriesLoaded) {
      return;
    }

    emit(currentState.copyWith(clearSelection: true));
  }

  // ============================================================
  // CREATE CATEGORY
  // ============================================================

  Future<void> createCategory({
    required String name,
    required XFile image,
  }) async {
    final currentState = state;

    if (currentState is! AdminCategoriesLoaded) {
      return;
    }

    final result = await createAdminCategoryUseCase(name: name, image: image);

    if (result.isLeft()) {
      result.fold((failure) {
        emit(AdminCategoriesError(failure.message));
      }, (_) {});

      emit(currentState);

      return;
    }

    await loadCategories();
  }

  // ============================================================
  // UPDATE CATEGORY
  // ============================================================

  Future<void> updateCategory({
    required String id,
    required String name,
    XFile? image,
  }) async {
    final currentState = state;

    if (currentState is! AdminCategoriesLoaded) {
      return;
    }

    final result = await updateAdminCategoryUseCase(
      id: id,
      name: name,
      image: image,
    );

    if (result.isLeft()) {
      result.fold((failure) {
        emit(AdminCategoriesError(failure.message));
      }, (_) {});

      emit(currentState);

      return;
    }

    await loadCategories();
  }

  // ============================================================
  // DELETE CATEGORY
  // ============================================================

  Future<void> deleteCategory({required String id}) async {
    final currentState = state;

    if (currentState is! AdminCategoriesLoaded) {
      return;
    }

    final result = await deleteAdminCategoryUseCase(id: id);

    if (result.isLeft()) {
      result.fold((failure) {
        emit(AdminCategoriesError(failure.message));
      }, (_) {});

      emit(currentState);

      return;
    }

    await loadCategories();
  }
}
