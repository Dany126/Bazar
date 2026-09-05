import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/usecases/create_admin_product.dart';
import 'package:e_commerce/features/admin/domain/usecases/create_admin_variant.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:image_picker/image_picker.dart';

class CreateAdminProductWithVariantsUseCase {
  final CreateAdminProductUseCase createProductUseCase;
  final CreateAdminVariantUseCase createVariantUseCase;

  const CreateAdminProductWithVariantsUseCase({
    required this.createProductUseCase,
    required this.createVariantUseCase,
  });

  Future<Either<Failure, ProductModel>> call({
    required String name,
    required String categoryId,
    required double price,
    required List<XFile> images,
    required List<AdminProductVariantInput> variants,
  }) async {
    final productResult = await createProductUseCase(
      name: name,
      categoryId: categoryId,
      price: price,
      images: images,
    );

    if (productResult.isLeft()) {
      return productResult.fold(
        (failure) => Left(failure),
        (_) => throw StateError('Invalid product result state.'),
      );
    }

    final product = productResult.fold(
      (_) => throw StateError('Invalid product result state.'),
      (value) => value,
    );

    if (product.id.isEmpty) {
      return const Left(
        ValidationFailure(
          message: 'Product was created but no product ID was returned.',
        ),
      );
    }

    for (final variant in variants) {
      final variantResult = await createVariantUseCase(
        productId: product.id,
        size: variant.size,
        color: variant.color,
        price: variant.price,
        stock: variant.stock,
      );

      if (variantResult.isLeft()) {
        return variantResult.fold(
          (failure) => Left(
            ServerFailure(
              message:
                  'Product created, but a variant failed: '
                  '${failure.message}',
            ),
          ),
          (_) => throw StateError('Invalid variant result state.'),
        );
      }
    }

    return Right(product);
  }
}

class AdminProductVariantInput {
  final String size;
  final String color;
  final double price;
  final int stock;

  const AdminProductVariantInput({
    required this.size,
    required this.color,
    required this.price,
    required this.stock,
  });
}
