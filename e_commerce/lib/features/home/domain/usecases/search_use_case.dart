import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/domain/repos/home_repo.dart';

class SearchUseCase {
  final HomeRepo homeRepo;
  SearchUseCase(this.homeRepo);
  Future<Either<Failure, List<ProductEntity>>> call({
    required String query,
    required int page,
    required int limit,
  }) {
    return homeRepo.search(query: query, page: page, limit: limit);
  }
}
