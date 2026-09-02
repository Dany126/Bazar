import 'package:e_commerce/features/order/data/model/order_model.dart';

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
  final List<OrderModel> orders;

  const AdminOrdersLoaded({required this.orders});
}

class AdminOrdersUpdating extends AdminOrdersState {
  final List<OrderModel> orders;

  const AdminOrdersUpdating({required this.orders});
}

class AdminOrdersUpdated extends AdminOrdersState {
  final List<OrderModel> orders;

  const AdminOrdersUpdated({required this.orders});
}

class AdminOrdersDeleting extends AdminOrdersState {
  final List<OrderModel> orders;

  const AdminOrdersDeleting({required this.orders});
}

class AdminOrdersDeleted extends AdminOrdersState {
  final List<OrderModel> orders;

  const AdminOrdersDeleted({required this.orders});
}

class AdminOrdersFailure extends AdminOrdersState {
  final String message;

  const AdminOrdersFailure({required this.message});
}
