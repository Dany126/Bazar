import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/features/address/domain/entity/address_entity.dart';
import 'package:e_commerce/features/address/domain/use_case/get_addresses_usecase.dart';
import 'package:e_commerce/features/payment_method/domain/entity/saved_card_entity.dart';
import 'package:e_commerce/features/payment_method/domain/use_case/get_saved_cards_use_case.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final GetAddressesUseCase getAddressesUseCase;
  final GetSavedCardsUseCase getSavedCardsUseCase;

  CheckoutCubit({
    required this.getAddressesUseCase,
    required this.getSavedCardsUseCase,
  }) : super(CheckoutInitial());

  Future<void> init() async {
    emit(CheckoutLoading());

    final addressResult = await getAddressesUseCase();
    final paymentResult = await getSavedCardsUseCase();

    final addresses = addressResult.fold((_) => <AddressEntity>[], (a) => a);
    final paymentMethods = paymentResult.fold(
      (_) => <SavedCardEntity>[],
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
        selectedAddress: _pickDefault<AddressEntity>(
          addresses,
          (address) => address.isDefault,
        ),
        paymentMethods: paymentMethods,
        selectedPaymentMethod: _pickDefault<SavedCardEntity>(
          paymentMethods,
          (method) => method.isDefault,
        ),
        selectedPaymentType: CheckoutPaymentType.card,
      ),
    );
  }

  T? _pickDefault<T>(List<T> items, bool Function(T) isDefault) {
    if (items.isEmpty) return null;

    for (final item in items) {
      if (isDefault(item)) return item;
    }

    return items.first;
  }

  void selectAddress(AddressEntity address) {
    final current = state;
    if (current is CheckoutLoaded) {
      emit(current.copyWith(selectedAddress: address));
    }
  }

  void selectPaymentMethod(SavedCardEntity method) {
    final current = state;
    if (current is CheckoutLoaded) {
      emit(
        current.copyWith(
          selectedPaymentMethod: method,
          selectedPaymentType: CheckoutPaymentType.card,
        ),
      );
    }
  }

  void selectCashPayment() {
    final current = state;
    if (current is CheckoutLoaded) {
      emit(current.copyWith(selectedPaymentType: CheckoutPaymentType.cash));
    }
  }

  void selectcardPayment() {
    final current = state;
    if (current is CheckoutLoaded) {
      emit(current.copyWith(selectedPaymentType: CheckoutPaymentType.card));
    }
  }
}
