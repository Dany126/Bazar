import 'package:e_commerce/features/order/data/model/order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:e_commerce/features/admin/domain/usecases/delete_admin_order.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_admin_order.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_all_admin_orders.dart';
import 'package:e_commerce/features/admin/domain/usecases/update_admin_order.dart';

import 'admin_orders_state.dart';

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
    if (isClosed) return;

    emit(const AdminOrdersLoading());

    final result = await getAllAdminOrders();

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(AdminOrdersFailure(message: failure.message));
      },
      (orders) {
        emit(AdminOrdersLoaded(orders: orders));
      },
    );
  }

  Future<void> getOrder({required String orderId}) async {
    if (isClosed) return;

    final result = await getAdminOrder(orderId: orderId);

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(AdminOrdersFailure(message: failure.message));
      },
      (order) {
        final currentOrders = _currentOrders;

        final index = currentOrders.indexWhere((item) => item.id == order.id);

        if (index != -1) {
          currentOrders[index] = order;
        } else {
          currentOrders.add(order);
        }

        emit(AdminOrdersLoaded(orders: currentOrders as  List <OrderModel>));
      },
    );
  }

  Future<void> updateOrder({
    required String orderId,
    required Map<String, dynamic> data,
  }) async {
    if (isClosed) return;

    final oldOrders = _currentOrders;

    emit(AdminOrdersUpdating(orders: oldOrders as List<OrderModel>));

    final result = await updateAdminOrder(orderId: orderId, data: data);

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(AdminOrdersFailure(message: failure.message));
      },
      (updatedOrder) {
        final orders = _currentOrders;

        final index = orders.indexWhere((item) => item.id == updatedOrder.id);

        if (index != -1) {
          orders[index] = updatedOrder;
        }

        emit(AdminOrdersUpdated(orders: orders as List<OrderModel> ));
      },
    );
  }

  Future<void> deleteOrder({required String orderId}) async {
    if (isClosed) return;

    final oldOrders = _currentOrders;

    emit(AdminOrdersDeleting(orders: oldOrders as  List <OrderModel>));

    final result = await deleteAdminOrder(orderId: orderId);

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(AdminOrdersFailure(message: failure.message));
      },
      (_) {
        final orders = _currentOrders
          ..removeWhere((order) => order.id == orderId);

        emit(AdminOrdersDeleted(orders: orders as List<OrderModel>));
      },
    );
  }

  List<dynamic> get _currentOrders {
    final currentState = state;

    if (currentState is AdminOrdersLoaded) {
      return List.of(currentState.orders);
    }

    if (currentState is AdminOrdersUpdating) {
      return List.of(currentState.orders);
    }

    if (currentState is AdminOrdersUpdated) {
      return List.of(currentState.orders);
    }

    if (currentState is AdminOrdersDeleting) {
      return List.of(currentState.orders);
    }

    if (currentState is AdminOrdersDeleted) {
      return List.of(currentState.orders);
    }

    return [];
  }
}
