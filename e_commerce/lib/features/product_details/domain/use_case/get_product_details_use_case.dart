// lib/features/product_details/domin/use_case/get_product_details_use_case.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/product_details/domain/entity/product_details_entity.dart';
import 'package:e_commerce/features/product_details/domain/repo/product_details_repo.dart';

class GetProductDetailsUseCase {
  final ProductDetailsRepository repository;

  GetProductDetailsUseCase(this.repository);

  Future<Either<Failure, ProductDetailsEntity>> call({
    required String productId,
  }) {
    return repository.getProductDetails(productId: productId);
  }
}
