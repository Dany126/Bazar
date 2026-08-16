import 'package:e_commerce/features/address/domain/entity/address_entity.dart';
import 'package:e_commerce/features/payment_method/domain/entity/payment_method_entity.dart';

sealed class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutError extends CheckoutState {
  final String message;
  CheckoutError(this.message);
}

class CheckoutLoaded extends CheckoutState {
  final List<AddressEntity> addresses;
  final AddressEntity? selectedAddress;
  final List<PaymentMethodEntity> paymentMethods;
  final PaymentMethodEntity? selectedPaymentMethod;

  CheckoutLoaded({
    required this.addresses,
    required this.selectedAddress,
    required this.paymentMethods,
    required this.selectedPaymentMethod,
  });

  CheckoutLoaded copyWith({
    List<AddressEntity>? addresses,
    AddressEntity? selectedAddress,
    List<PaymentMethodEntity>? paymentMethods,
    PaymentMethodEntity? selectedPaymentMethod,
  }) {
    return CheckoutLoaded(
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
    );
  }
}
