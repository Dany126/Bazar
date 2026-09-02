import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';

abstract class AdminProductRepository {
  Future<Either<Failure, List<ProductModel>>> getAllProducts();

  Future<Either<Failure, ProductModel>> createProduct({
    required String name,
    required String categoryId,
    required double price,
    required int stock,
    String? description,
    required List<String> imagePaths,
  });

  Future<Either<Failure, ProductModel>> updateProduct({
    required String id,
    String? name,
    String? categoryId,
    double? price,
    int? stock,
    bool? isActive,
    String? description,
  });

  Future<Either<Failure, Unit>> deleteProduct(String id);
}
