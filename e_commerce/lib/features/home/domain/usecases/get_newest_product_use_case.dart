import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/domain/repos/home_repo.dart';

class GetNewtestProductUseCase {
  final HomeRepo homeRepo;
  GetNewtestProductUseCase(this.homeRepo);
  Future<Either<Failure, List<ProductEntity>>> call({
    required int page,
    required int limit,
  }) {
    return homeRepo.getNewestProducts(page: page, limit: limit);
  }
}
