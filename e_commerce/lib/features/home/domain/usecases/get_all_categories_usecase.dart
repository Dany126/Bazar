import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/domain/entity/category_entity.dart';
import 'package:e_commerce/features/home/domain/repos/home_repo.dart';

class GetAllCategoriesUseCase {
  final HomeRepo homeRepo;

  const GetAllCategoriesUseCase(this.homeRepo);

  Future<Either<Failure, List<CategoryEntity>>> call() {
    return homeRepo.getAllCategories();
  }
}
