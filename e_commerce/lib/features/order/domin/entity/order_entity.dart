class OrderModel {
  final String id;
  final int itemsCount;
  final String status; // Processing, Shipped, Delivered, Returned, Cancelled

  const OrderModel({
    required this.id,
    required this.itemsCount,
    required this.status,
  });
}
