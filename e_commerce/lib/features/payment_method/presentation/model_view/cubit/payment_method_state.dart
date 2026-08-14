// lib/features/payment_method/presenation/modelview/cubit/payment_method_state.dart
import 'package:e_commerce/features/payment_method/domain/entity/payment_method_entity.dart';

abstract class PaymentMethodState {}

class PaymentMethodInitial extends PaymentMethodState {}

class PaymentMethodLoading extends PaymentMethodState {}

class PaymentMethodLoaded extends PaymentMethodState {
  final List<PaymentMethodEntity> paymentMethods;
  PaymentMethodLoaded(this.paymentMethods);
}

class PaymentMethodError extends PaymentMethodState {
  final String message;
  PaymentMethodError(this.message);
}
