import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_order_repository.dart';
import 'package:e_commerce/features/order/data/model/order_model.dart';

class GetAllAdminOrders {
  final AdminOrderRepository repository;

  GetAllAdminOrders(this.repository);

  Future<Either<Failure, List<OrderModel>>> call() {
    return repository.getAllOrders();
  }
}
