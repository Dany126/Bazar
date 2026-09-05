import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_category_repository.dart';

class DeleteAdminCategoryUseCase {
  final AdminCategoriesRepository repository;

  const DeleteAdminCategoryUseCase({required this.repository});

  Future<Either<Failure, void>> call({required String id}) {
    return repository.deleteCategory(id: id);
  }
}
