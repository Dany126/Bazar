import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_order_repository.dart';
import 'package:e_commerce/features/order/data/model/order_model.dart';

class UpdateAdminOrder {
  final AdminOrderRepository repository;

  UpdateAdminOrder(this.repository);

  Future<Either<Failure, OrderModel>> call({
    required String orderId,
    required Map<String, dynamic> data,
  }) {
    return repository.updateOrder(orderId: orderId, data: data);
  }
}
