import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/order/domin/repo/order_repo.dart';

import '../../../../core/error/failure.dart';
import '../entity/order_entity.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call({
    required List<Map<String, dynamic>> products,
    required double totalPrice,
    required Map<String, dynamic> shippingAddress,
    required String paymentMethod,
  }) {
    return repository.createOrder(
      products: products,
      totalPrice: totalPrice,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
    );
  }
}
