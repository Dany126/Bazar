import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/address/domain/entity/address_entity.dart';
import 'package:e_commerce/features/address/domain/entity/picked_location_entity.dart';
import 'package:e_commerce/features/address/domain/entity/search_result_entity.dart';

sealed class AddressState {}

final class AddressInitial extends AddressState {}

// --- Map picking ---
final class AddressLocating extends AddressState {}

final class AddressResolving extends AddressState {}

// --- Save / list (matches what AddAddressViewBody already listens for) ---
final class AddressLoading extends AddressState {}

final class AddressLoaded extends AddressState {
  final AddressEntity address;
  AddressLoaded(this.address);
}

final class AddressListLoaded extends AddressState {
  final List<AddressEntity> addresses;
  AddressListLoaded(this.addresses);
}

final class AddressError extends AddressState {
  final Failure message;
  AddressError(this.message);
}

final class AddressDeleted extends AddressState {}

final class AddressLocationPicked extends AddressState {
  final PickedLocationEntity location;
  final bool recenter; // true when the map should animate to this point
  AddressLocationPicked(this.location, {this.recenter = false});
}

// --- Search ---
final class AddressSearchLoading extends AddressState {}

final class AddressSearchLoaded extends AddressState {
  final List<SearchResultEntity> results;
  AddressSearchLoaded(this.results);
}

final class AddressSearchError extends AddressState {
  final String message;
  AddressSearchError(this.message);
}
