import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/use_case/use_case.dart';
import 'package:e_commerce/features/home/domain/entity/category_entity.dart';
import 'package:e_commerce/features/home/domain/repos/home_repo.dart';

class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, NoParams> {
  final HomeRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) {
    return repository.getCategories();
  }
}
