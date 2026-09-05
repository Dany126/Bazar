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

  const AdminOrdersLoaded({
    required this.orders,
    required this.filteredOrders,
    this.searchQuery = '',
    this.updatingOrderId,
    this.deletingOrderId,
  });

  AdminOrdersLoaded copyWith({
    List<OrderEntity>? orders,
    List<OrderEntity>? filteredOrders,
    String? searchQuery,
    String? updatingOrderId,
    String? deletingOrderId,
    bool clearUpdatingOrderId = false,
    bool clearDeletingOrderId = false,
  }) {
    return AdminOrdersLoaded(
      orders: orders ?? this.orders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
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

class AdminOrdersError extends AdminOrdersState {
  final String message;

  const AdminOrdersError({required this.message});
}
