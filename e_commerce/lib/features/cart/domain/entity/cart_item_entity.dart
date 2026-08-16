class CartItemEntity {
  final String id; // this line-item's own _id within products[]
  final String productId;
  final String variantId;
  final int quantity;

  final String? name;
  final String? image;
  final double? price;
  final String? size;
  final String? color;
  final int? stock;

  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.variantId,
    required this.quantity,
    this.name,
    this.image,
    this.price,
    this.size,
    this.color,
    this.stock,
  });

  double? get lineTotal => price == null ? null : price! * quantity;
}
