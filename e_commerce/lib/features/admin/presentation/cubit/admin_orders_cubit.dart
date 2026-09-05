import 'package:e_commerce/features/order/domin/entity/order_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:e_commerce/features/admin/domain/usecases/delete_admin_order.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_admin_order.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_all_admin_orders.dart';
import 'package:e_commerce/features/admin/domain/usecases/update_admin_order.dart';

import 'package:e_commerce/features/admin/presentation/cubit/admin_orders_state.dart';

class AdminOrdersCubit
    extends Cubit<AdminOrdersState> {
  final GetAllAdminOrders getAllAdminOrders;
  final GetAdminOrder getAdminOrder;
  final UpdateAdminOrder updateAdminOrder;
  final DeleteAdminOrder deleteAdminOrder;

  AdminOrdersCubit({
    required this.getAllAdminOrders,
    required this.getAdminOrder,
    required this.updateAdminOrder,
    required this.deleteAdminOrder,
  }) : super(
          const AdminOrdersInitial(),
        );

  // ============================================================
  // PAGINATION CONFIG
  // ============================================================

  static const int defaultItemsPerPage = 10;

  // ============================================================
  // LOAD ORDERS
  // ============================================================

  Future<void> loadOrders() async {
    emit(
      const AdminOrdersLoading(),
    );

    final result =
        await getAllAdminOrders();

    result.fold(
      (failure) {
        emit(
          AdminOrdersError(
            message: failure.message,
          ),
        );
      },
      (orders) {
        emit(
          AdminOrdersLoaded(
            orders: orders,
            filteredOrders: orders,
            currentPage: 1,
            itemsPerPage:
                defaultItemsPerPage,
          ),
        );
      },
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void searchOrders(
    String query,
  ) {
    final currentState = state;

    if (currentState
        is! AdminOrdersLoaded) {
      return;
    }

    final filtered =
        _filterOrders(
      currentState.orders,
      query,
    );

    emit(
      currentState.copyWith(
        filteredOrders: filtered,
        searchQuery: query,
        currentPage: 1,
      ),
    );
  }

  // ============================================================
  // CLEAR SEARCH
  // ============================================================

  void clearSearch() {
    final currentState = state;

    if (currentState
        is! AdminOrdersLoaded) {
      return;
    }

    emit(
      currentState.copyWith(
        filteredOrders:
            currentState.orders,
        searchQuery: '',
        currentPage: 1,
      ),
    );
  }

  // ============================================================
  // FILTER
  // ============================================================

  List<OrderEntity> _filterOrders(
    List<OrderEntity> orders,
    String query,
  ) {
    final value =
        query.trim().toLowerCase();

    if (value.isEmpty) {
      return orders;
    }

    return orders.where(
      (order) {
        final id =
            order.id.toLowerCase();

        final orderStatus =
            order.orderStatus
                .toLowerCase();

        final paymentStatus =
            order.paymentStatus
                .toLowerCase();

        return id.contains(value) ||
            orderStatus.contains(value) ||
            paymentStatus.contains(value);
      },
    ).toList();
  }

  // ============================================================
  // GO TO PAGE
  // ============================================================

  void goToPage(
    int page,
  ) {
    final currentState = state;

    if (currentState
        is! AdminOrdersLoaded) {
      return;
    }

    final totalPages =
        currentState.totalPages;

    if (page < 1 ||
        page > totalPages) {
      return;
    }

    if (page ==
        currentState.currentPage) {
      return;
    }

    emit(
      currentState.copyWith(
        currentPage: page,
      ),
    );
  }

  // ============================================================
  // NEXT PAGE
  // ============================================================

  void nextPage() {
    final currentState = state;

    if (currentState
        is! AdminOrdersLoaded) {
      return;
    }

    if (!currentState.hasNextPage) {
      return;
    }

    emit(
      currentState.copyWith(
        currentPage:
            currentState.currentPage + 1,
      ),
    );
  }

  // ============================================================
  // PREVIOUS PAGE
  // ============================================================

  void previousPage() {
    final currentState = state;

    if (currentState
        is! AdminOrdersLoaded) {
      return;
    }

    if (!currentState.hasPreviousPage) {
      return;
    }

    emit(
      currentState.copyWith(
        currentPage:
            currentState.currentPage - 1,
      ),
    );
  }

  // ============================================================
  // FIRST PAGE
  // ============================================================

  void firstPage() {
    final currentState = state;

    if (currentState
        is! AdminOrdersLoaded) {
      return;
    }

    emit(
      currentState.copyWith(
        currentPage: 1,
      ),
    );
  }

  // ============================================================
  // LAST PAGE
  // ============================================================

  void lastPage() {
    final currentState = state;

    if (currentState
        is! AdminOrdersLoaded) {
      return;
    }

    emit(
      currentState.copyWith(
        currentPage:
            currentState.totalPages,
      ),
    );
  }

  // ============================================================
  // ITEMS PER PAGE
  // ============================================================

  void changeItemsPerPage(
    int value,
  ) {
    final currentState = state;

    if (currentState
        is! AdminOrdersLoaded) {
      return;
    }

    emit(
      currentState.copyWith(
        itemsPerPage: value,
        currentPage: 1,
      ),
    );
  }

  // ============================================================
  // UPDATE ORDER STATUS
  // ============================================================

  Future<void> updateOrderStatus({
    required String orderId,
    required String orderStatus,
  }) async {
    final currentState = state;

    if (currentState
        is! AdminOrdersLoaded) {
      return;
    }

    emit(
      currentState.copyWith(
        updatingOrderId: orderId,
      ),
    );

    final result =
        await updateAdminOrder(
      orderId: orderId,
      data: {
        'orderStatus': orderStatus,
      },
    );

    result.fold(
      (failure) {
        emit(
          currentState.copyWith(
            clearUpdatingOrderId: true,
          ),
        );
      },
      (updatedOrder) {
        final updatedOrders =
            currentState.orders
                .map(
                  (order) {
                    if (order.id ==
                        updatedOrder.id) {
                      return updatedOrder;
                    }

                    return order;
                  },
                )
                .toList();

        final filteredOrders =
            _filterOrders(
          updatedOrders,
          currentState.searchQuery,
        );

        int page =
            currentState.currentPage;

        final totalPages =
            filteredOrders.isEmpty
                ? 1
                : (filteredOrders.length /
                        currentState.itemsPerPage)
                    .ceil();

        if (page > totalPages) {
          page = totalPages;
        }

        emit(
          AdminOrdersLoaded(
            orders: updatedOrders,
            filteredOrders:
                filteredOrders,
            searchQuery:
                currentState.searchQuery,
            currentPage: page,
            itemsPerPage:
                currentState.itemsPerPage,
          ),
        );
      },
    );
  }

  // ============================================================
  // DELETE ORDER
  // ============================================================

  Future<void> deleteOrder(
    String orderId,
  ) async {
    final currentState = state;

    if (currentState
        is! AdminOrdersLoaded) {
      return;
    }

    emit(
      currentState.copyWith(
        deletingOrderId: orderId,
      ),
    );

    final result =
        await deleteAdminOrder(
      orderId: orderId,
    );

    result.fold(
      (failure) {
        emit(
          currentState.copyWith(
            clearDeletingOrderId: true,
          ),
        );
      },
      (_) {
        final updatedOrders =
            currentState.orders
                .where(
                  (order) =>
                      order.id != orderId,
                )
                .toList();

        final filteredOrders =
            _filterOrders(
          updatedOrders,
          currentState.searchQuery,
        );

        int page =
            currentState.currentPage;

        final totalPages =
            filteredOrders.isEmpty
                ? 1
                : (filteredOrders.length /
                        currentState.itemsPerPage)
                    .ceil();

        if (page > totalPages) {
          page = totalPages;
        }

        emit(
          AdminOrdersLoaded(
            orders: updatedOrders,
            filteredOrders:
                filteredOrders,
            searchQuery:
                currentState.searchQuery,
            currentPage: page,
            itemsPerPage:
                currentState.itemsPerPage,
          ),
        );
      },
    );
  }

  // ============================================================
  // GET SINGLE ORDER
  // ============================================================

  Future<OrderEntity?> getOrder(
    String orderId,
  ) async {
    final result =
        await getAdminOrder(
      orderId: orderId,
    );

    return result.fold(
      (_) => null,
      (order) => order,
    );
  }
}