import 'cart_item_entity.dart';

class CartEntity {
  final String id;
  final String userId;
  final List<CartItemEntity> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CartEntity({
    required this.id,
    required this.userId,
    required this.items,
    this.createdAt,
    this.updatedAt,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double? get subtotal {
    double sum = 0;
    for (final item in items) {
      final lineTotal = item.lineTotal;
      if (lineTotal == null) return null;
      sum += lineTotal;
    }
    return sum;
  }
}
