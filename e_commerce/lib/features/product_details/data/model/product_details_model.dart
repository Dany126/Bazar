
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_cubit.dart';
import 'package:e_commerce/features/product_details/data/model/review_model.dart';
import 'package:e_commerce/features/product_details/data/model/variant_model.dart';
import 'package:e_commerce/features/product_details/domain/entity/product_details_entity.dart';

class ProductDetailsModel extends ProductDetailsEntity {
  ProductDetailsModel({
    required super.id,
    required super.name,
    required super.price,
    required super.images,
    required super.avgRating,
    required super.ratingsQuantity,
    required super.stock,
    required super.soldCount,
    required super.categoryId,
    super.description,
    super.isFavorite = false,
    super.variants,
    super.reviews,
  });

  // ============================================================
  // FROM JSON
  // ============================================================

  factory ProductDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final variantsRaw = json['variants'];

    final variants = variantsRaw is List
        ? variantsRaw
            .whereType<Map<String, dynamic>>()
            .map(
              (variant) => VariantModel.fromJson(
                variant,
              ),
            )
            .toList()
        : <VariantModel>[];

    final productId =
        json['_id']?.toString() ??
        json['id']?.toString() ??
        '';

    return ProductDetailsModel(
      id: productId,

      name: json['name']?.toString() ?? '',

      // ----------------------------------------------------------
      // BASE PRODUCT PRICE
      // ----------------------------------------------------------
      //
      // Product price is stored directly in:
      //
      // json['price']
      //
      // Variant price is stored separately in VariantModel.price.
      //
      price: _toDouble(
        json['price'],
      ),

      // ----------------------------------------------------------
      // MULTIPLE IMAGES
      // ----------------------------------------------------------

      images: _parseImages(
        json['image'],
      ),

      // ----------------------------------------------------------
      // RATING
      // ----------------------------------------------------------

      avgRating: _toRating(
        json['avg_rating'],
      ),

      ratingsQuantity: _toInt(
        json['ratingsQuantity'],
      ),

      // ----------------------------------------------------------
      // STOCK
      // ----------------------------------------------------------

      stock: _toInt(
        json['stock'],
      ),

      // ----------------------------------------------------------
      // SOLD COUNT
      // ----------------------------------------------------------

      soldCount: _toInt(
        json['soldCount'],
      ),

      // ----------------------------------------------------------
      // CATEGORY
      // ----------------------------------------------------------

      categoryId: _parseCategoryId(
        json['category'],
      ),

      // ----------------------------------------------------------
      // DESCRIPTION
      // ----------------------------------------------------------

      description: json['description']?.toString(),

      // ----------------------------------------------------------
      // REVIEWS
      // ----------------------------------------------------------

      reviews: _parseReviews(
        json['reviews'],
      ),

      // ----------------------------------------------------------
      // VARIANTS
      // ----------------------------------------------------------

      variants: variants,

      // ----------------------------------------------------------
      // FAVORITE
      // ----------------------------------------------------------

      isFavorite: _getFavoriteState(
        productId,
        json['isFavorite'],
        json['isFavourite'],
        json['isInWishlist'],
      ),
    );
  }

  // ============================================================
  // FROM VARIANTS JSON
  // ============================================================
  //
  // Your API response looks like:
  //
  // {
  //   "status": "Success",
  //   "variants": [
  //     {
  //       "_id": "...",
  //       "size": "S",
  //       "price": 500,
  //       "color": "Black",
  //       "stock": 11,
  //       "soldCount": 4,
  //
  //       "product": {
  //         "_id": "...",
  //         "name": "Dany",
  //         "image": [
  //           "...",
  //           "...",
  //           "...",
  //           "..."
  //         ],
  //         "avg_rating": 0,
  //         "ratingsQuantity": 0,
  //         "category": {...},
  //         "price": 100
  //       }
  //     }
  //   ],
  //   "noOfVariants": 1
  // }
  //
  // Therefore:
  //
  // Base product price = 100
  // Variant price      = 500
  // Final price        = 600
  //
  // ProductDetailsModel.price = 100
  // VariantModel.price        = 500
  //
  // ProductDetailsViewBody calculates 100 + 500.

  factory ProductDetailsModel.fromVariantsJson({
    required Map<String, dynamic> product,
    required List<dynamic> variantsJson,
  }) {
    // ----------------------------------------------------------
    // PARSE VARIANTS
    // ----------------------------------------------------------

    final variantMaps = variantsJson
        .whereType<Map<String, dynamic>>()
        .toList();

    final variants = variantMaps
        .map(
          (variant) => VariantModel.fromJson(
            variant,
          ),
        )
        .toList();

    // ----------------------------------------------------------
    // FIRST VARIANT
    // ----------------------------------------------------------

    final firstVariant =
        variantMaps.isNotEmpty
            ? variantMaps.first
            : null;

    // ----------------------------------------------------------
    // PRODUCT INSIDE VARIANT
    // ----------------------------------------------------------
    //
    // The API returns:
    //
    // variant.product.price
    //
    // as the base product price.

    Map<String, dynamic>? variantProduct;

    if (firstVariant != null) {
      final productData = firstVariant['product'];

      if (productData is Map<String, dynamic>) {
        variantProduct = productData;
      }
    }

    // ----------------------------------------------------------
    // PRODUCT ID
    // ----------------------------------------------------------

    final productId =
        product['_id']?.toString() ??
        product['id']?.toString() ??
        variantProduct?['_id']?.toString() ??
        variantProduct?['id']?.toString() ??
        '';

    // ----------------------------------------------------------
    // PRODUCT NAME
    // ----------------------------------------------------------

    final productName =
        product['name']?.toString() ??
        variantProduct?['name']?.toString() ??
        '';

    // ----------------------------------------------------------
    // BASE PRODUCT PRICE
    // ----------------------------------------------------------
    //
    // IMPORTANT:
    //
    // DO NOT use:
    //
    // firstVariant['price']
    //
    // because that is the variant price.
    //
    // We need:
    //
    // product['price']
    //
    // OR:
    //
    // variantProduct['price']
    //
    // In your actual response:
    //
    // variant.price = 500
    // variant.product.price = 100

    final basePrice =
        product['price'] ??
        variantProduct?['price'];

    // ----------------------------------------------------------
    // PRODUCT IMAGES
    // ----------------------------------------------------------

    final productImages =
        product['image'] ??
        variantProduct?['image'];

    // ----------------------------------------------------------
    // PRODUCT CATEGORY
    // ----------------------------------------------------------

    final category =
        product['category'] ??
        variantProduct?['category'];

    // ----------------------------------------------------------
    // PRODUCT DESCRIPTION
    // ----------------------------------------------------------

    final description =
        product['description'] ??
        variantProduct?['description'];

    // ----------------------------------------------------------
    // PRODUCT RATING
    // ----------------------------------------------------------

    final avgRating =
        product['avg_rating'] ??
        variantProduct?['avg_rating'];

    final ratingsQuantity =
        product['ratingsQuantity'] ??
        variantProduct?['ratingsQuantity'];

    // ----------------------------------------------------------
    // PRODUCT REVIEWS
    // ----------------------------------------------------------

    final reviews =
        product['reviews'] ??
        variantProduct?['reviews'];

    // ----------------------------------------------------------
    // FAVORITE STATE
    // ----------------------------------------------------------

    final isFavorite =
        product['isFavorite'] ??
        variantProduct?['isFavorite'];

    final isFavourite =
        product['isFavourite'] ??
        variantProduct?['isFavourite'];

    final isInWishlist =
        product['isInWishlist'] ??
        variantProduct?['isInWishlist'];

    // ----------------------------------------------------------
    // PRODUCT SOLD COUNT
    // ----------------------------------------------------------

    final soldCount =
        product['soldCount'] ??
        variantProduct?['soldCount'];

    // ----------------------------------------------------------
    // PRODUCT STOCK
    // ----------------------------------------------------------
    //
    // Stock belongs to the variant.
    //
    // The first variant is the initial/default variant.
    //
    // When the user selects another variant, your UI should use
    // that selected variant's stock.

    final productStock =
        product['stock'] ??
        variantProduct?['stock'];

    // ----------------------------------------------------------
    // RETURN MODEL
    // ----------------------------------------------------------

    return ProductDetailsModel(
      id: productId,

      name: productName,

      // ========================================================
      // BASE PRODUCT PRICE
      // ========================================================
      //
      // Your example:
      //
      // product.price = 100
      // variant.price = 500
      //
      // Therefore:
      //
      // ProductDetailsModel.price = 100
      //
      price: _toDouble(
        basePrice,
      ),

      // ========================================================
      // ALL PRODUCT IMAGES
      // ========================================================

      images: _parseImages(
        productImages,
      ),

      // ========================================================
      // RATING
      // ========================================================

      avgRating: _toRating(
        avgRating,
      ),

      ratingsQuantity: _toInt(
        ratingsQuantity,
      ),

      // ========================================================
      // STOCK
      // ========================================================
      //
      // ProductDetailsEntity still requires a product stock.
      //
      // Use the first variant's stock when variants exist.
      //

      stock: firstVariant != null
          ? _toInt(
              firstVariant['stock'],
            )
          : _toInt(
              productStock,
            ),

      // ========================================================
      // SOLD COUNT
      // ========================================================
      //
      // This is the PRODUCT sold count.
      //
      // We do NOT access:
      //
      // variant.soldCount
      //
      // because VariantEntity does not have soldCount.

      soldCount: _toInt(
        soldCount,
      ),

      // ========================================================
      // CATEGORY
      // ========================================================

      categoryId: _parseCategoryId(
        category,
      ),

      // ========================================================
      // DESCRIPTION
      // ========================================================

      description: description?.toString(),

      // ========================================================
      // REVIEWS
      // ========================================================

      reviews: _parseReviews(
        reviews,
      ),

      // ========================================================
      // VARIANTS
      // ========================================================

      variants: variants,

      // ========================================================
      // FAVORITE
      // ========================================================

      isFavorite: _getFavoriteState(
        productId,
        isFavorite,
        isFavourite,
        isInWishlist,
      ),
    );
  }

  // ============================================================
  // FAVORITE STATE
  // ============================================================

  static bool _getFavoriteState(
    String productId,
    dynamic isFavorite,
    dynamic isFavourite,
    dynamic isInWishlist,
  ) {
    final sharedState =
        GetProductsCubit.favoriteProductIds.value;

    if (sharedState.containsKey(productId)) {
      return sharedState[productId] == true;
    }

    if (isFavorite == true) {
      return true;
    }

    if (isFavourite == true) {
      return true;
    }

    if (isInWishlist == true) {
      return true;
    }

    return false;
  }

  // ============================================================
  // DOUBLE PARSER
  // ============================================================

  static double _toDouble(
    dynamic value,
  ) {
    if (value == null) {
      return 0.0;
    }

    double result;

    if (value is num) {
      result = value.toDouble();
    } else {
      result =
          double.tryParse(
            value.toString().trim(),
          ) ??
          0.0;
    }

    if (!result.isFinite) {
      return 0.0;
    }

    return result;
  }

  // ============================================================
  // RATING PARSER
  // ============================================================

  static double _toRating(
    dynamic value,
  ) {
    final rating = _toDouble(
      value,
    );

    if (!rating.isFinite) {
      return 0.0;
    }

    if (rating <= 0) {
      return 0.0;
    }

    if (rating >= 5) {
      return 5.0;
    }

    return rating;
  }

  // ============================================================
  // INT PARSER
  // ============================================================

  static int _toInt(
    dynamic value,
  ) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value.toString().trim(),
        ) ??
        0;
  }

  // ============================================================
  // IMAGES PARSER
  // ============================================================

  static List<String> _parseImages(
    dynamic value,
  ) {
    if (value is! List) {
      return <String>[];
    }

    return value
        .where(
          (image) => image != null,
        )
        .map(
          (image) => image.toString().trim(),
        )
        .where(
          (image) => image.isNotEmpty,
        )
        .toList();
  }

  // ============================================================
  // REVIEWS PARSER
  // ============================================================

  static List<ReviewModel> _parseReviews(
    dynamic value,
  ) {
    if (value is! List) {
      return <ReviewModel>[];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map(
          (review) => ReviewModel.fromJson(
            review,
          ),
        )
        .toList();
  }

  // ============================================================
  // CATEGORY ID PARSER
  // ============================================================

  static String _parseCategoryId(
    dynamic category,
  ) {
    if (category is String) {
      return category;
    }

    if (category is Map<String, dynamic>) {
      return category['_id']?.toString() ??
          category['id']?.toString() ??
          '';
    }

    return '';
  }

  // ============================================================
  // TO MAP
  // ============================================================

  Map<String, dynamic> toMap() {
    return {
      '_id': id,

      'name': name,

      // Base product price.
      'price': price,

      // All product images.
      'image': images,

      'avg_rating': avgRating,

      'ratingsQuantity': ratingsQuantity,

      'stock': stock,

      'soldCount': soldCount,

      'category': categoryId,

      if (description != null)
        'description': description,

      'isFavorite': isFavorite,

      // --------------------------------------------------------
      // VARIANTS
      // --------------------------------------------------------
      //
      // VariantEntity contains:
      // id
      // size
      // color
      // price
      // stock
      //
      // It does NOT contain soldCount.

      'variants': variants
          .map(
            (variant) => {
              '_id': variant.id,
              'size': variant.size,
              'color': variant.color,
              'price': variant.price,
              'stock': variant.stock,
            },
          )
          .toList(),
    };
  }

  // ============================================================
  // TO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return toMap();
  }
}
