import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';

import '../repositories/admin_category_repository.dart';

class DeleteAdminCategory {
  final AdminCategoryRepository repository;

  DeleteAdminCategory(this.repository);

  Future<Either<Failure, Unit>> call({required String categoryId}) {
    return repository.deleteCategory(categoryId: categoryId);
  }
}
