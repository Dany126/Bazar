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

    final productId = productRaw is String
        ? productRaw
        : (productRaw as Map<String, dynamic>?)?['_id']?.toString() ?? '';

    final variantId = variantRaw is String
        ? variantRaw
        : (variantRaw as Map<String, dynamic>?)?['_id']?.toString() ?? '';

    final productMap = productRaw is Map<String, dynamic> ? productRaw : null;
    final variantMap = variantRaw is Map<String, dynamic> ? variantRaw : null;

    final images = productMap?['image'];
    final image = images is List && images.isNotEmpty
        ? images.first?.toString()
        : null;

    return CartItemModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      productId: productId,
      variantId: variantId,
      quantity: _toInt(json['quantity']) ?? 1,
      name: productMap?['name']?.toString(),
      image: image,
      price: _toDouble(variantMap?['price'] ?? productMap?['price']),
      size: variantMap?['size']?.toString(),
      color: variantMap?['color']?.toString(),
      stock: _toInt(variantMap?['stock']),
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
