import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/features/address/domain/entity/address_entity.dart';
import 'package:e_commerce/features/address/domain/use_case/get_addresses_usecase.dart';
import 'package:e_commerce/features/payment_method/domain/entity/payment_method_entity.dart';
import 'package:e_commerce/features/payment_method/domain/use_case/get_payment_methods_use_case.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final GetAddressesUseCase getAddressesUseCase;
  final GetPaymentMethodsUseCase getPaymentMethodsUseCase;

  CheckoutCubit({
    required this.getAddressesUseCase,
    required this.getPaymentMethodsUseCase,
  }) : super(CheckoutInitial());

  Future<void> init() async {
    emit(CheckoutLoading());

    final addressResult = await getAddressesUseCase();
    final paymentResult = await getPaymentMethodsUseCase();

    final addresses = addressResult.fold((_) => <AddressEntity>[], (a) => a);
    final paymentMethods = paymentResult.fold(
      (_) => <PaymentMethodEntity>[],
      (p) => p,
    );

    // Surface an error only if BOTH failed — partial data is still usable.
    if (addressResult.isLeft() && paymentResult.isLeft()) {
      emit(CheckoutError('Failed to load checkout details'));
      return;
    }

    emit(
      CheckoutLoaded(
        addresses: addresses,
        selectedAddress: _pickDefault(addresses, (a) => a.isDefault),
        paymentMethods: paymentMethods,
        selectedPaymentMethod: _pickDefault(paymentMethods, (p) => p.isDefault),
      ),
    );
  }

  T? _pickDefault<T>(List<T> items, bool Function(T) isDefault) {
    if (items.isEmpty) return null;
    return items.firstWhere(isDefault, orElse: () => items.first);
  }

  void selectAddress(AddressEntity address) {
    final current = state;
    if (current is CheckoutLoaded) {
      emit(current.copyWith(selectedAddress: address));
    }
  }

  void selectPaymentMethod(PaymentMethodEntity method) {
    final current = state;
    if (current is CheckoutLoaded) {
      emit(current.copyWith(selectedPaymentMethod: method));
    }
  }
}
