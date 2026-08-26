import 'package:e_commerce/features/order/domin/entity/order_entity.dart';
import 'package:e_commerce/features/order/domin/use_case/create_order_use_case.dart';
import 'package:e_commerce/features/order/domin/use_case/get_order_use_case.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/order_view_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final CreateOrderUseCase createOrderUseCase;
  final GetOrdersUseCase getOrdersUseCase;

  OrderCubit({required this.createOrderUseCase, required this.getOrdersUseCase})
    : super(OrderInitial());

  /// Returns the created order on success, or null on failure
  /// (OrderError is still emitted either way, so the BlocListener
  /// keeps working for the cash-on-delivery flow).
  Future<OrderEntity?> createOrder({
    required List<Map<String, dynamic>> products,
    required double totalPrice,
    required Map<String, dynamic> shippingAddress,
    required String paymentMethod,
  }) async {
    emit(OrderLoading());

    final result = await createOrderUseCase(
      products: products,
      totalPrice: totalPrice,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
    );

    return result.fold(
      (failure) {
        emit(OrderError(failure.message));
        return null;
      },
      (order) {
        emit(OrderCreated(order));
        
        return order;
      },
    );
  }

  Future<void> getMyOrders({required OrderStatus filter}) async {
    emit(OrderLoading());

    final result = await getOrdersUseCase(filter: filter);

    result.fold(
      (failure) {
        emit(OrderError(failure.message));
      },
      (orders) {
        emit(OrdersLoaded(orders));
      },
    );
  }
}
