import 'package:e_commerce/features/address/domain/entity/address_entity.dart';
import 'package:e_commerce/features/payment_method/domain/entity/saved_card_entity.dart';

enum CheckoutPaymentType { cash, card }

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
  final List<SavedCardEntity> paymentMethods;
  final SavedCardEntity? selectedPaymentMethod;
  final CheckoutPaymentType selectedPaymentType;

  CheckoutLoaded({
    required this.addresses,
    required this.selectedAddress,
    required this.paymentMethods,
    required this.selectedPaymentMethod,
    required this.selectedPaymentType,
  });

  CheckoutLoaded copyWith({
    List<AddressEntity>? addresses,
    AddressEntity? selectedAddress,
    List<SavedCardEntity>? paymentMethods,
    SavedCardEntity? selectedPaymentMethod,
    CheckoutPaymentType? selectedPaymentType,
  }) {
    return CheckoutLoaded(
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      selectedPaymentType: selectedPaymentType ?? this.selectedPaymentType,
    );
  }
}
