import 'package:e_commerce/features/order/domin/entity/order_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/features/admin/domain/usecases/delete_admin_order.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_admin_order.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_all_admin_orders.dart';
import 'package:e_commerce/features/admin/domain/usecases/update_admin_order.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_orders_state.dart';

class AdminOrdersCubit extends Cubit<AdminOrdersState> {
  final GetAllAdminOrders getAllAdminOrders;
  final GetAdminOrder getAdminOrder;
  final UpdateAdminOrder updateAdminOrder;
  final DeleteAdminOrder deleteAdminOrder;

  AdminOrdersCubit({
    required this.getAllAdminOrders,
    required this.getAdminOrder,
    required this.updateAdminOrder,
    required this.deleteAdminOrder,
  }) : super(const AdminOrdersInitial());

  Future<void> loadOrders() async {
    emit(const AdminOrdersLoading());

    final result = await getAllAdminOrders();

    result.fold(
      (failure) {
        emit(AdminOrdersError(message: failure.message));
      },
      (orders) {
        emit(AdminOrdersLoaded(orders: orders, filteredOrders: orders));
      },
    );
  }

  void searchOrders(String query) {
    final currentState = state;

    if (currentState is! AdminOrdersLoaded) {
      return;
    }

    final filtered = _filterOrders(currentState.orders, query);

    emit(currentState.copyWith(filteredOrders: filtered, searchQuery: query));
  }

  void clearSearch() {
    final currentState = state;

    if (currentState is! AdminOrdersLoaded) {
      return;
    }

    emit(
      currentState.copyWith(
        filteredOrders: currentState.orders,
        searchQuery: '',
      ),
    );
  }

  List<OrderEntity> _filterOrders(List<OrderEntity> orders, String query) {
    final value = query.trim().toLowerCase();

    if (value.isEmpty) {
      return orders;
    }

    return orders.where((order) {
      final id = order.id.toLowerCase();
      final orderStatus = order.orderStatus.toLowerCase();
      final paymentStatus = order.paymentStatus.toLowerCase();

      return id.contains(value) ||
          orderStatus.contains(value) ||
          paymentStatus.contains(value);
    }).toList();
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required String orderStatus,
  }) async {
    final currentState = state;

    if (currentState is! AdminOrdersLoaded) {
      return;
    }

    emit(currentState.copyWith(updatingOrderId: orderId));

    final result = await updateAdminOrder(
      orderId: orderId,
      data: {'orderStatus': orderStatus},
    );

    result.fold(
      (failure) {
        emit(currentState.copyWith(clearUpdatingOrderId: true));
      },
      (updatedOrder) {
        final updatedOrders = currentState.orders.map((order) {
          if (order.id == updatedOrder.id) {
            return updatedOrder;
          }

          return order;
        }).toList();

        emit(
          AdminOrdersLoaded(
            orders: updatedOrders,
            filteredOrders: _filterOrders(
              updatedOrders,
              currentState.searchQuery,
            ),
            searchQuery: currentState.searchQuery,
          ),
        );
      },
    );
  }

  Future<void> deleteOrder(String orderId) async {
    final currentState = state;

    if (currentState is! AdminOrdersLoaded) {
      return;
    }

    emit(currentState.copyWith(deletingOrderId: orderId));

    final result = await deleteAdminOrder(orderId: orderId);

    result.fold(
      (failure) {
        emit(currentState.copyWith(clearDeletingOrderId: true));
      },
      (_) {
        final updatedOrders = currentState.orders
            .where((order) => order.id != orderId)
            .toList();

        emit(
          AdminOrdersLoaded(
            orders: updatedOrders,
            filteredOrders: _filterOrders(
              updatedOrders,
              currentState.searchQuery,
            ),
            searchQuery: currentState.searchQuery,
          ),
        );
      },
    );
  }

  Future<OrderEntity?> getOrder(String orderId) async {
    final result = await getAdminOrder(orderId: orderId);

    return result.fold((_) => null, (order) => order);
  }
}
