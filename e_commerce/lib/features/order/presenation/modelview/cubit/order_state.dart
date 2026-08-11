import 'package:e_commerce/features/order/domin/entity/order_entity.dart';

abstract class OrderState {
  const OrderState();
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderCreated extends OrderState {
  final OrderEntity order;

  const OrderCreated(this.order);
}

class OrdersLoaded extends OrderState {
  final List<OrderEntity> orders;

  const OrdersLoaded(this.orders);
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);
}
