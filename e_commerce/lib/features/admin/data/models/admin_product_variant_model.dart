class AdminProductVariantModel {
  final String? id;
  final String size;
  final String color;
  final double price;
  final int stock;
  final int soldCount;
  final String? productId;

  const AdminProductVariantModel({
    this.id,
    required this.size,
    required this.color,
    required this.price,
    required this.stock,
    this.soldCount = 0,
    this.productId,
  });

  factory AdminProductVariantModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'];

    return AdminProductVariantModel(
      id: json['_id']?.toString(),
      size: json['size']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      price: _toDouble(json['price']),
      stock: _toInt(json['stock']),
      soldCount: _toInt(json['soldCount']),
      productId: product is Map
          ? product['_id']?.toString()
          : product?.toString(),
    );
  }

  Map<String, dynamic> toJson({required String productId}) {
    return {
      'size': size,
      'color': color,
      'price': price,
      'stock': stock,
      'product': productId,
    };
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
