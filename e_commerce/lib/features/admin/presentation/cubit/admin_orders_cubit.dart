import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:e_commerce/features/admin/domain/entity/admin_orders_page.dart';

import 'package:e_commerce/features/admin/domain/usecases/delete_admin_order.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_admin_order.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_all_admin_orders.dart';
import 'package:e_commerce/features/admin/domain/usecases/update_admin_order.dart';

import 'package:e_commerce/features/admin/presentation/cubit/admin_orders_state.dart';

import 'package:e_commerce/features/order/domin/entity/order_entity.dart';

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

  // ============================================================
  // CONFIG
  // ============================================================

  static const int defaultItemsPerPage = 10;

  // ============================================================
  // LOAD ORDERS
  // ============================================================

  Future<void> loadOrders({int page = 1}) async {
    final bool isFirstLoad =
        state is AdminOrdersInitial || state is AdminOrdersError;

    if (isFirstLoad) {
      emit(const AdminOrdersLoading());
    } else if (state is AdminOrdersLoaded) {
      final current = state as AdminOrdersLoaded;

      emit(
        AdminOrdersLoadingPage(
          previousPage: current.pageData,
          searchQuery: current.searchQuery,
          updatingOrderId: current.updatingOrderId,
          deletingOrderId: current.deletingOrderId,
        ),
      );
    }

    final result = await getAllAdminOrders(
      page: page,
      limit: defaultItemsPerPage,
    );

    result.fold(
      (failure) {
        emit(AdminOrdersError(message: failure.message));
      },
      (ordersPage) {
        String searchQuery = '';

        if (state is AdminOrdersLoadingPage) {
          searchQuery = (state as AdminOrdersLoadingPage).searchQuery;
        }

        emit(AdminOrdersLoaded(pageData: ordersPage, searchQuery: searchQuery));
      },
    );
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refreshOrders() async {
    await loadOrders(page: 1);
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void searchOrders(String query) {
    final currentState = state;

    if (currentState is AdminOrdersLoaded) {
      emit(currentState.copyWith(searchQuery: query));

      return;
    }

    if (currentState is AdminOrdersLoadingPage) {
      emit(
        AdminOrdersLoadingPage(
          previousPage: currentState.previousPage,
          searchQuery: query,
          updatingOrderId: currentState.updatingOrderId,
          deletingOrderId: currentState.deletingOrderId,
        ),
      );
    }
  }

  // ============================================================
  // CLEAR SEARCH
  // ============================================================

  void clearSearch() {
    final currentState = state;

    if (currentState is AdminOrdersLoaded) {
      emit(currentState.copyWith(searchQuery: ''));
    }
  }

  // ============================================================
  // NEXT PAGE
  // ============================================================

  Future<void> nextPage() async {
    final currentState = state;

    if (currentState is! AdminOrdersLoaded) {
      return;
    }

    if (!currentState.hasNextPage) {
      return;
    }

    await loadOrders(page: currentState.currentPage + 1);
  }

  // ============================================================
  // PREVIOUS PAGE
  // ============================================================

  Future<void> previousPage() async {
    final currentState = state;

    if (currentState is! AdminOrdersLoaded) {
      return;
    }

    if (!currentState.hasPreviousPage) {
      return;
    }

    await loadOrders(page: currentState.currentPage - 1);
  }

  // ============================================================
  // FIRST PAGE
  // ============================================================

  Future<void> firstPage() async {
    final currentState = state;

    if (currentState is! AdminOrdersLoaded) {
      return;
    }

    if (!currentState.hasPreviousPage) {
      return;
    }

    await loadOrders(page: 1);
  }

  // ============================================================
  // LAST PAGE
  // ============================================================

  Future<void> lastPage() async {
    final currentState = state;

    if (currentState is! AdminOrdersLoaded) {
      return;
    }

    if (!currentState.hasNextPage) {
      return;
    }

    await loadOrders(page: currentState.totalPages);
  }

  // ============================================================
  // GO TO PAGE
  // ============================================================

  Future<void> goToPage(int page) async {
    final currentState = state;

    if (currentState is! AdminOrdersLoaded) {
      return;
    }

    if (page < 1 || page > currentState.totalPages) {
      return;
    }

    if (page == currentState.currentPage) {
      return;
    }

    await loadOrders(page: page);
  }

  // ============================================================
  // UPDATE ORDER STATUS
  // ============================================================

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

        emit(AdminOrdersError(message: failure.message));
      },
      (updatedOrder) {
        final updatedOrders = currentState.orders.map((order) {
          if (order.id == updatedOrder.id) {
            return updatedOrder;
          }

          return order;
        }).toList();

        final updatedPage = AdminOrdersPage(
          orders: updatedOrders,
          currentPage: currentState.currentPage,
          itemsPerPage: currentState.itemsPerPage,
          totalOrders: currentState.totalItems,
          totalPages: currentState.totalPages,
        );

        emit(
          AdminOrdersLoaded(
            pageData: updatedPage,
            searchQuery: currentState.searchQuery,
          ),
        );
      },
    );
  }

  // ============================================================
  // DELETE ORDER
  // ============================================================

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

        emit(AdminOrdersError(message: failure.message));
      },
      (_) async {
        // Reload current page from server so pagination stays correct.
        final currentPage = currentState.currentPage;

        await loadOrders(page: currentPage);
      },
    );
  }

  // ============================================================
  // GET SINGLE ORDER
  // ============================================================

  Future<OrderEntity?> getOrder(String orderId) async {
    final result = await getAdminOrder(orderId: orderId);

    return result.fold((_) => null, (order) => order);
  }
}
