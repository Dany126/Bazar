import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/domain/repos/home_repo.dart';

class GetAllProductsByCategoriesUseCase {
  final HomeRepo homeRepo;
  GetAllProductsByCategoriesUseCase(this.homeRepo);

  Future<Either<Failure, List<ProductEntity>>> call({
    required int page,
    required int limit,
    required String categoryId,
  }) {
    return homeRepo.getProductsByCategory(
      category: categoryId,
      page: 1,
      limit: 10,
    );
  }
}
