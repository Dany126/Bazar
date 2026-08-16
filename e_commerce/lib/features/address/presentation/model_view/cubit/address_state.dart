import 'package:e_commerce/features/address/domain/entity/address_entity.dart';

sealed class AddressState {}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressError extends AddressState {
  final String message;
  AddressError(this.message);
}

class AddressLoaded extends AddressState {
  final List<AddressEntity> addresses;
  AddressLoaded(this.addresses);
}
