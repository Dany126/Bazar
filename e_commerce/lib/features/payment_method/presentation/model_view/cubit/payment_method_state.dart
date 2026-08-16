import 'package:e_commerce/features/payment_method/domain/entity/payment_method_entity.dart';

sealed class PaymentMethodState {}

class PaymentMethodInitial extends PaymentMethodState {}

class PaymentMethodLoading extends PaymentMethodState {}

class PaymentMethodError extends PaymentMethodState {
  final String message;
  PaymentMethodError(this.message);
}

class PaymentMethodLoaded extends PaymentMethodState {
  final List<PaymentMethodEntity> paymentMethods;
  PaymentMethodLoaded(this.paymentMethods);
}
