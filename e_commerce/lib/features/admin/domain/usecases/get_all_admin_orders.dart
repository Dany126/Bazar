import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_orders_page.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_order_repository.dart';

class GetAllAdminOrders {
  final AdminOrderRepository repository;

  GetAllAdminOrders(this.repository);

  Future<Either<Failure, AdminOrdersPage>> call({
    required int page,
    required int limit,
  }) {
    return repository.getAllOrders(page: page, limit: limit);
  }
}
