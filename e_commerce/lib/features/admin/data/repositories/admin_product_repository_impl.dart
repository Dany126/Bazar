import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/data/datasources/admin_product_remote_data_source.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_product_repository.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:image_picker/image_picker.dart';

class AdminProductRepositoryImpl implements AdminProductRepository {
  final AdminProductRemoteDataSource remoteDataSource;

  AdminProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() {
    return remoteDataSource.getAllProducts();
  }

  @override
  Future<Either<Failure, ProductModel>> createProduct({
    required String name,
    required String categoryId,
    required double price,
    required List<XFile> images,
  }) {
    return remoteDataSource.createProduct(
      name: name,
      categoryId: categoryId,
      price: price,
      images: images,
    );
  }

  @override
  Future<Either<Failure, ProductModel>> updateProduct({
    required String id,
    String? name,
    String? categoryId,
    double? price,
    List<XFile>? images,
  }) {
    return remoteDataSource.updateProduct(
      id: id,
      name: name,
      categoryId: categoryId,
      price: price,
      images: images,
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String id) {
    return remoteDataSource.deleteProduct(id);
  }
}
