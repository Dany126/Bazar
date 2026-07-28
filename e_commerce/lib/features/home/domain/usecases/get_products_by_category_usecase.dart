import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/use_case/use_case.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/domain/repos/home_repo.dart';
import 'package:equatable/equatable.dart';

class GetProductsByCategoryParams extends Equatable {
  final String categoryId;
  final int page;
  final int limit;

  const GetProductsByCategoryParams({
    required this.categoryId,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [categoryId, page, limit];
}

class GetProductsByCategoryUseCase
    implements UseCase<List<ProductEntity>, GetProductsByCategoryParams> {
  final HomeRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    GetProductsByCategoryParams params,
  ) {
    return repository.getProductsByCategory(
      categoryId: params.categoryId,
      page: params.page,
      limit: params.limit,
    );
  }
}
