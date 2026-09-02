import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_admin_category.dart';
import '../../domain/usecases/delete_admin_category.dart';
import 'admin_categories_state.dart';

class AdminCategoriesCubit extends Cubit<AdminCategoriesState> {
  final CreateAdminCategory createAdminCategory;
  final DeleteAdminCategory deleteAdminCategory;

  AdminCategoriesCubit({
    required this.createAdminCategory,
    required this.deleteAdminCategory,
  }) : super(const AdminCategoriesInitial());

  Future<void> createCategory({
    required String name,
    required MultipartFile image,
  }) async {
    if (isClosed) return;

    emit(const AdminCategoriesCreating());

    final result = await createAdminCategory(name: name, image: image);

    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;

        emit(AdminCategoriesFailure(failure.message));
      },
      (category) {
        if (isClosed) return;

        emit(AdminCategoriesCreated(category));
      },
    );
  }

  Future<void> deleteCategory({required String categoryId}) async {
    if (isClosed) return;

    emit(AdminCategoriesDeleting(categoryId));

    final result = await deleteAdminCategory(categoryId: categoryId);

    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;

        emit(AdminCategoriesFailure(failure.message));
      },
      (_) {
        if (isClosed) return;

        emit(AdminCategoriesDeleted(categoryId));
      },
    );
  }
}
