import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/order/domin/repo/order_repo.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/order_view_body.dart';

import '../../../../core/error/failure.dart';
import '../entity/order_entity.dart';

class GetOrdersUseCase {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);
  Future<Either<Failure, List<OrderEntity>>> call({
    required String userId,
    required OrderStatus filter,
  }) {
    return repository.getMyOrders(userId: userId, orderStatus: filter);
  }
}
