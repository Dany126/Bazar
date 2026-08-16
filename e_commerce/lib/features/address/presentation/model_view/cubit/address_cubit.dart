import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/features/address/domain/use_case/add_address_use_case.dart';
import 'package:e_commerce/features/address/domain/use_case/delete_address_use_case.dart';
import 'package:e_commerce/features/address/domain/use_case/get_addresses_use_case.dart';
import 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final GetAddressesUseCase getAddressesUseCase;
  final AddAddressUseCase addAddressUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;

  AddressCubit({
    required this.getAddressesUseCase,
    required this.addAddressUseCase,
    required this.deleteAddressUseCase,
  }) : super(AddressInitial());

  Future<void> getAddresses() async {
    emit(AddressLoading());
    final result = await getAddressesUseCase();
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (addresses) => emit(AddressLoaded(addresses)),
    );
  }

  Future<void> addAddress({
    required String street,
    required String city,
    required String country,
    required String postalCode,
    bool isDefault = false,
  }) async {
    final result = await addAddressUseCase(
      street: street,
      city: city,
      country: country,
      postalCode: postalCode,
      isDefault: isDefault,
    );
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (_) => getAddresses(),
    );
  }

  Future<void> deleteAddress(String addressId) async {
    final result = await deleteAddressUseCase(addressId: addressId);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (_) => getAddresses(),
    );
  }
}
