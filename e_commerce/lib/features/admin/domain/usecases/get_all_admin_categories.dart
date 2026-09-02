import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_category_repository.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';

class GetAllAdminCategoriesUseCase {
  final AdminCategoriesRepository repository;

  const GetAllAdminCategoriesUseCase({required this.repository});

  Future<Either<Failure, List<CategoryModel>>> call() {
    return repository.getAllCategories();
  }
}
