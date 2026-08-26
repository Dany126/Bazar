import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<Either<Failure, List<CategoryModel>>> getAllCategories();

  Future<Either<Failure, List<ProductModel>>> getAllProducts({
    required int page,
    required int limit,
  });

  Future<Either<Failure, List<ProductModel>>> getBestSellingProducts({
    required int page,
    required int limit,
  });

  Future<Either<Failure, List<ProductModel>>> getNewestProducts({
    required int page,
    required int limit,
  });

  Future<Either<Failure, List<ProductModel>>> getProductsByCategory({
    required String category,
    required int page,
    required int limit,
  });

  Future<Either<Failure, List<ProductModel>>> search({
    required String query,
    required int page,
    required int limit,
  });

  Future<Either<Failure, List<ProductModel>>> getFavoriteProducts({
    required int page,
    required int limit,
  });

  // NEW
  Future<Either<Failure, Set<String>>> getFavoriteProductIds();

  Future<Either<Failure, Unit>> changeToIsFavourite({
    required String productId,
    required bool isFavourite,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiService apiService;

  HomeRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<Failure, List<CategoryModel>>> getAllCategories() async {
    final response = await apiService.get(kGetAllGategories);

    return response.fold((failure) => Left(failure), (data) {
      final categoriesJson = (data['categories'] as List<dynamic>?) ?? [];

      final categories = categoriesJson
          .whereType<Map<String, dynamic>>()
          .map(CategoryModel.fromJson)
          .toList();

      return Right(categories);
    });
  }

  // ============================================================
  // GET FAVORITE PRODUCT IDs
  // ============================================================

  @override
  Future<Either<Failure, Set<String>>> getFavoriteProductIds() async {
    final response = await apiService.get(
      "$kBaseUrl/wishlist",
      queryParameters: {'page': 1, 'limit': 1000},
    );

    return response.fold(
      (failure) {
        log('GET FAVORITE IDS ERROR: $failure');
        return Left(failure);
      },
      (data) {
        final Set<String> favoriteIds = {};

        final wishlists = (data['wishList'] as List<dynamic>?) ?? [];

        for (final wishlist in wishlists) {
          if (wishlist is! Map<String, dynamic>) {
            continue;
          }

          final product = wishlist['product'];

          // product is an object
          if (product is Map<String, dynamic>) {
            final id = product['_id']?.toString();

            if (id != null && id.isNotEmpty) {
              favoriteIds.add(id);
            }
          }

          // product is a list
          if (product is List) {
            for (final item in product) {
              if (item is Map<String, dynamic>) {
                final id = item['_id']?.toString();

                if (id != null && id.isNotEmpty) {
                  favoriteIds.add(id);
                }
              }
            }
          }
        }

        log('FAVORITE IDS: $favoriteIds');

        return Right(favoriteIds);
      },
    );
  }

  // ============================================================
  // ALL PRODUCTS
  // ============================================================

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts({
    required int page,
    required int limit,
  }) async {
    final response = await apiService.get(
      kGetAllProducts,
      queryParameters: {'page': page, 'limit': limit},
    );

    return response.fold((failure) => Left(failure), (data) {
      final productsJson = (data['products'] as List<dynamic>?) ?? [];

      final products = productsJson
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();

      return Right(products);
    });
  }

  // ============================================================
  // FAVORITES
  // ============================================================

  @override
  Future<Either<Failure, List<ProductModel>>> getFavoriteProducts({
    required int page,
    required int limit,
  }) async {
    final response = await apiService.get(
      "$kBaseUrl/wishlist",
      queryParameters: {'page': page, 'limit': limit},
    );

    return response.fold(
      (failure) {
        log('GET FAVORITES ERROR: $failure');
        return Left(failure);
      },
      (data) {
        final wishlists = (data['wishList'] as List<dynamic>?) ?? [];

        final productsJson = wishlists
            .whereType<Map<String, dynamic>>()
            .expand((wishlist) {
              final product = wishlist['product'];

              if (product is List) {
                return product;
              }

              if (product is Map<String, dynamic>) {
                return [product];
              }

              return const [];
            })
            .whereType<Map<String, dynamic>>()
            .toList();

        final products = productsJson.map((json) {
          return ProductModel.fromJson(json)..isFavorite = true;
        }).toList();

        return Right(products);
      },
    );
  }

  // ============================================================
  // BEST SELLING
  // ============================================================

  @override
  Future<Either<Failure, List<ProductModel>>> getBestSellingProducts({
    required int page,
    required int limit,
  }) async {
    final response = await apiService.get(
      kGetBestSellerProductByCategory,
      queryParameters: {'page': page, 'limit': limit, 'sort': '-stock'},
    );

    return response.fold((failure) => Left(failure), (data) {
      final productsJson = (data['products'] as List<dynamic>?) ?? [];

      final products = productsJson
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();

      return Right(products);
    });
  }

  // ============================================================
  // NEWEST
  // ============================================================

  @override
  Future<Either<Failure, List<ProductModel>>> getNewestProducts({
    required int page,
    required int limit,
  }) async {
    final response = await apiService.get(
      kGetNewProductByCategory,
      queryParameters: {'page': page, 'limit': limit, 'sort': '-createdAt'},
    );

    return response.fold((failure) => Left(failure), (data) {
      final productsJson = (data['products'] as List<dynamic>?) ?? [];

      final products = productsJson
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();

      return Right(products);
    });
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory({
    required String category,
    required int page,
    required int limit,
  }) async {
    final response = await apiService.get(
      "$kGetProductByCategory/$category/product",
      queryParameters: {'page': page, 'limit': limit},
    );

    return response.fold((failure) => Left(failure), (data) {
      final productsJson = (data['products'] as List<dynamic>?) ?? [];

      final products = productsJson
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();

      return Right(products);
    });
  }

  // ============================================================
  // SEARCH
  // ============================================================

  @override
  Future<Either<Failure, List<ProductModel>>> search({
    required String query,
    required int page,
    required int limit,
  }) async {
    final response = await apiService.get(
      "$kBaseUrl/search",
      queryParameters: {'page': page, 'limit': limit, 'q': query},
    );

    return response.fold((failure) => Left(failure), (data) {
      final productsJson = (data['products'] as List<dynamic>?) ?? [];

      final products = productsJson
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();

      return Right(products);
    });
  }

  // ============================================================
  // ADD / REMOVE FAVORITE
  // ============================================================

  @override
  Future<Either<Failure, Unit>> changeToIsFavourite({
    required String productId,
    required bool isFavourite,
  }) async {
    if (isFavourite) {
      final response = await apiService.post("$kBaseUrl/wishlist/$productId");

      return response.fold((failure) => Left(failure), (_) => Right(unit));
    }

    final response = await apiService.delete("$kBaseUrl/wishlist/$productId");

    return response.fold((failure) => Left(failure), (_) => Right(unit));
  }
}
