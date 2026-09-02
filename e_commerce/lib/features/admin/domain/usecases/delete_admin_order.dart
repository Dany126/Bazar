import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_order_repository.dart';

class DeleteAdminOrder {
  final AdminOrderRepository repository;

  DeleteAdminOrder(this.repository);

  Future<Either<Failure, Unit>> call({required String orderId}) {
    return repository.deleteOrder(orderId: orderId);
  }
}
