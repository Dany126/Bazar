import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/use_case/use_case.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/domain/repos/home_repo.dart';
import 'package:equatable/equatable.dart';

class GetNewProductsParams extends Equatable {
  final int page;
  final int limit;

  const GetNewProductsParams({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

class GetNewProductsUseCase
    implements UseCase<List<ProductEntity>, GetNewProductsParams> {
  final HomeRepository repository;

  GetNewProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    GetNewProductsParams params,
  ) {
    return repository.getNewProducts(page: params.page, limit: params.limit);
  }
}
