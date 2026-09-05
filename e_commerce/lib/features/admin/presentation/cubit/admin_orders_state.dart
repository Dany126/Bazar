import 'package:e_commerce/features/admin/domain/entity/admin_orders_page.dart';
import 'package:e_commerce/features/order/domin/entity/order_entity.dart';

abstract class AdminOrdersState {
  const AdminOrdersState();
}

// ============================================================
// INITIAL
// ============================================================

class AdminOrdersInitial extends AdminOrdersState {
  const AdminOrdersInitial();
}

// ============================================================
// FIRST LOAD
// ============================================================

class AdminOrdersLoading extends AdminOrdersState {
  const AdminOrdersLoading();
}

// ============================================================
// PAGE LOADING
// ============================================================

class AdminOrdersLoadingPage extends AdminOrdersState {
  final AdminOrdersPage previousPage;

  final String searchQuery;

  final String? updatingOrderId;
  final String? deletingOrderId;

  const AdminOrdersLoadingPage({
    required this.previousPage,
    this.searchQuery = '',
    this.updatingOrderId,
    this.deletingOrderId,
  });
}

// ============================================================
// LOADED
// ============================================================

class AdminOrdersLoaded extends AdminOrdersState {
  final AdminOrdersPage pageData;

  final String searchQuery;

  final String? updatingOrderId;
  final String? deletingOrderId;

  const AdminOrdersLoaded({
    required this.pageData,
    this.searchQuery = '',
    this.updatingOrderId,
    this.deletingOrderId,
  });

  // ==========================================================
  // EASY ACCESS
  // ==========================================================

  List<OrderEntity> get orders => pageData.orders;

  List<OrderEntity> get filteredOrders {
    final query = searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return orders;
    }

    return orders.where((order) {
      return order.id.toLowerCase().contains(query) ||
          order.orderStatus.toLowerCase().contains(query) ||
          order.paymentStatus.toLowerCase().contains(query) ||
          order.paymentMethod.toLowerCase().contains(query);
    }).toList();
  }

  int get currentPage => pageData.currentPage;

  int get itemsPerPage => pageData.itemsPerPage;

  int get totalItems => pageData.totalOrders;

  int get totalPages => pageData.totalPages;

  bool get hasPreviousPage =>
      pageData.hasPreviousPage;

  bool get hasNextPage =>
      pageData.hasNextPage;

  List<OrderEntity> get paginatedOrders =>
      filteredOrders;

  int get startItem {
    if (filteredOrders.isEmpty) {
      return 0;
    }

    return pageData.startItem;
  }

  int get endItem {
    if (filteredOrders.isEmpty) {
      return 0;
    }

    return pageData.endItem;
  }

  AdminOrdersLoaded copyWith({
    AdminOrdersPage? pageData,
    String? searchQuery,
    String? updatingOrderId,
    String? deletingOrderId,
    bool clearUpdatingOrderId = false,
    bool clearDeletingOrderId = false,
  }) {
    return AdminOrdersLoaded(
      pageData: pageData ?? this.pageData,
      searchQuery: searchQuery ?? this.searchQuery,
      updatingOrderId: clearUpdatingOrderId
          ? null
          : updatingOrderId ?? this.updatingOrderId,
      deletingOrderId: clearDeletingOrderId
          ? null
          : deletingOrderId ?? this.deletingOrderId,
    );
  }
}

// ============================================================
// ERROR
// ============================================================

class AdminOrdersError extends AdminOrdersState {
  final String message;

  const AdminOrdersError({
    required this.message,
  });
}