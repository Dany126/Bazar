import 'package:e_commerce/features/order/domin/entity/order_entity.dart';

class AdminOrdersPage {
  final List<OrderEntity> orders;

  final int currentPage;
  final int itemsPerPage;
  final int totalOrders;
  final int totalPages;

  const AdminOrdersPage({
    required this.orders,
    required this.currentPage,
    required this.itemsPerPage,
    required this.totalOrders,
    required this.totalPages,
  });

  bool get hasPreviousPage => currentPage > 1;

  bool get hasNextPage => currentPage < totalPages;

  int get startItem {
    if (totalOrders == 0) {
      return 0;
    }

    return ((currentPage - 1) * itemsPerPage) + 1;
  }

  int get endItem {
    if (totalOrders == 0 || orders.isEmpty) {
      return 0;
    }

    final end = startItem + orders.length - 1;

    return end > totalOrders ? totalOrders : end;
  }
}
