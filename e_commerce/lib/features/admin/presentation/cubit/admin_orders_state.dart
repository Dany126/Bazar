import 'package:e_commerce/features/order/domin/entity/order_entity.dart';

abstract class AdminOrdersState {
  const AdminOrdersState();
}

class AdminOrdersInitial extends AdminOrdersState {
  const AdminOrdersInitial();
}

class AdminOrdersLoading extends AdminOrdersState {
  const AdminOrdersLoading();
}

class AdminOrdersLoaded extends AdminOrdersState {
  final List<OrderEntity> orders;
  final List<OrderEntity> filteredOrders;

  final String searchQuery;

  final String? updatingOrderId;
  final String? deletingOrderId;

  // Pagination
  final int currentPage;
  final int itemsPerPage;

  const AdminOrdersLoaded({
    required this.orders,
    required this.filteredOrders,
    this.searchQuery = '',
    this.updatingOrderId,
    this.deletingOrderId,
    this.currentPage = 1,
    this.itemsPerPage = 10,
  });

  int get totalItems => filteredOrders.length;

  int get totalPages {
    if (filteredOrders.isEmpty) {
      return 1;
    }

    return (filteredOrders.length / itemsPerPage).ceil();
  }

  List<OrderEntity> get paginatedOrders {
    if (filteredOrders.isEmpty) {
      return const [];
    }

    final startIndex =
        (currentPage - 1) * itemsPerPage;

    if (startIndex >= filteredOrders.length) {
      return const [];
    }

    final endIndex =
        (startIndex + itemsPerPage)
            .clamp(0, filteredOrders.length);

    return filteredOrders.sublist(
      startIndex,
      endIndex,
    );
  }

  bool get hasPreviousPage =>
      currentPage > 1;

  bool get hasNextPage =>
      currentPage < totalPages;

  AdminOrdersLoaded copyWith({
    List<OrderEntity>? orders,
    List<OrderEntity>? filteredOrders,
    String? searchQuery,
    String? updatingOrderId,
    String? deletingOrderId,
    int? currentPage,
    int? itemsPerPage,
    bool clearUpdatingOrderId = false,
    bool clearDeletingOrderId = false,
  }) {
    return AdminOrdersLoaded(
      orders: orders ?? this.orders,
      filteredOrders:
          filteredOrders ?? this.filteredOrders,
      searchQuery:
          searchQuery ?? this.searchQuery,
      updatingOrderId: clearUpdatingOrderId
          ? null
          : updatingOrderId ??
              this.updatingOrderId,
      deletingOrderId: clearDeletingOrderId
          ? null
          : deletingOrderId ??
              this.deletingOrderId,
      currentPage:
          currentPage ?? this.currentPage,
      itemsPerPage:
          itemsPerPage ?? this.itemsPerPage,
    );
  }
}

class AdminOrdersError extends AdminOrdersState {
  final String message;

  const AdminOrdersError({
    required this.message,
  });
}