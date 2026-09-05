import 'package:e_commerce/features/cart/domain/entity/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.productId,
    required super.variantId,
    required super.quantity,
    super.name,
    super.image,
    super.price,
    super.size,
    super.color,
    super.stock,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final productRaw = json['product'];
    final variantRaw = json['variant'];

    // ------------------------------------------------------------
    // PRODUCT ID
    // ------------------------------------------------------------

    final productId = productRaw is String
        ? productRaw
        : productRaw is Map
        ? productRaw['_id']?.toString() ?? ''
        : '';

    // ------------------------------------------------------------
    // VARIANT ID
    // ------------------------------------------------------------

    final variantId = variantRaw is String
        ? variantRaw
        : variantRaw is Map
        ? variantRaw['_id']?.toString() ?? ''
        : '';

    // ------------------------------------------------------------
    // POPULATED PRODUCT / VARIANT
    // ------------------------------------------------------------

    final productMap = productRaw is Map
        ? Map<String, dynamic>.from(productRaw)
        : null;

    final variantMap = variantRaw is Map
        ? Map<String, dynamic>.from(variantRaw)
        : null;

    // ------------------------------------------------------------
    // IMAGE
    // ------------------------------------------------------------

    final images = productMap?['image'];

    final image = images is List && images.isNotEmpty
        ? images.first?.toString()
        : null;

    // ------------------------------------------------------------
    // PRODUCT PRICE
    // ------------------------------------------------------------

    final productPrice = _toDouble(productMap?['price']) ?? 0.0;

    // ------------------------------------------------------------
    // VARIANT PRICE
    // ------------------------------------------------------------

    final variantPrice = _toDouble(variantMap?['price']) ?? 0.0;

    // ------------------------------------------------------------
    // FINAL PRICE
    //
    // Backend order validation uses:
    //
    // product.price + variant.price
    //
    // So Flutter must send the exact same value.
    // ------------------------------------------------------------

    final finalPrice = productPrice + variantPrice;

    return CartItemModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',

      productId: productId,

      variantId: variantId,

      quantity: _toInt(json['quantity']) ?? 1,

      name: productMap?['name']?.toString(),

      image: image,

      price: finalPrice,

      size: variantMap?['size']?.toString(),

      color: variantMap?['color']?.toString(),

      stock: _toInt(variantMap?['stock']),
    );
  }

  // ------------------------------------------------------------
  // INT PARSER
  // ------------------------------------------------------------

  static int? _toInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString());
  }

  // ------------------------------------------------------------
  // DOUBLE PARSER
  // ------------------------------------------------------------

  static double? _toDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }
}
