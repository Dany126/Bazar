import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_commerce/features/address/domain/entity/search_result_entity.dart';
import 'package:e_commerce/features/address/domain/use_case/edit_address_usecase.dart';
import 'package:e_commerce/features/address/domain/use_case/search_places_usecase.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_state.dart';
import 'package:latlong2/latlong.dart';

import '../../../domain/entity/address_entity.dart';
import '../../../domain/entity/picked_location_entity.dart';
import '../../../domain/use_case/add_address_usecase.dart';
import '../../../domain/use_case/delete_address_usecase.dart';
import '../../../domain/use_case/get_addresses_usecase.dart';
import '../../../domain/use_case/get_current_location_usecase.dart';
import '../../../domain/use_case/reverse_geocode_usecase.dart';
import '../../../domain/use_case/set_default_address_usecase.dart';

class AddressCubit extends Cubit<AddressState> {
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final ReverseGeocodeUseCase reverseGeocodeUseCase;
  final AddAddressUseCase addAddressUseCase;
  final GetAddressesUseCase getAddressesUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;
  final SetDefaultAddressUseCase setDefaultAddressUseCase;
  final EditAddressUseCase editAddressUseCase;
  final SearchPlacesUseCase searchPlacesUseCase;

  Timer? _searchDebounce;
  AddressCubit({
    required this.getCurrentLocationUseCase,
    required this.reverseGeocodeUseCase,
    required this.editAddressUseCase,
    required this.addAddressUseCase,
    required this.getAddressesUseCase,
    required this.deleteAddressUseCase,
    required this.setDefaultAddressUseCase,
    required this.searchPlacesUseCase,
  }) : super(AddressInitial());

  /// Cached separately from the emitted state so the picked pin survives
  /// transient states (AddressLoading/AddressError) — both the map screen
  /// and the form always have somewhere to read the last resolved location.
  PickedLocationEntity? pickedLocation;
  LatLng? _lastCenter;
  Timer? _debounce;

  Future<LatLng?> loadInitialLocation() async {
    emit(AddressLocating());
    final result = await getCurrentLocationUseCase();
    return result.fold(
      (failure) {
        emit(AddressError(failure));
        return null;
      },
      (position) {
        final target = LatLng(position.latitude, position.longitude);
        pickedLocation = PickedLocationEntity(
          latitude: position.latitude,
          longitude: position.longitude,
          street: '',
          city: '',
          country: '',
          postalCode: '',
          formattedAddress: '',
        );
        _resolve(target.latitude, target.longitude);
        return target;
      },
    );
  }

  Future<void> editAddress(AddressEntity address) async {
    emit(AddressLoading());
    final result = await editAddressUseCase(address);
    result.fold(
      (failure) => emit(AddressError(failure)),
      (updatedAddress) => emit(AddressLoaded(updatedAddress)),
    );
  }

  /// Called when opening the form in edit mode, so the map/AreaCard show
  /// the address's existing location without requiring the user to
  /// re-pick a pin.
  void startEditingAddress(AddressEntity address) {
    pickedLocation = PickedLocationEntity(
      latitude: address.latitude,
      longitude: address.longitude,
      street: address.street,
      city: address.city,
      country: address.country,
      postalCode: address.postalCode,
      formattedAddress: address.street,
    );
    emit(AddressLocationPicked(pickedLocation!));
  }

  /// Called on every map move — just tracks position, no network call.
  void onMapMove(LatLng target) {
    _lastCenter = target;
  }

  /// Debounced — call once the map settles so a drag doesn't fire a
  /// reverse-geocode request per frame.
  void onMapIdle() {
    if (_lastCenter == null) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _resolve(_lastCenter!.latitude, _lastCenter!.longitude);
    });
  }

  Future<void> _resolve(double lat, double lng, {bool recenter = false}) async {
    emit(AddressResolving());
    final result = await reverseGeocodeUseCase(latitude: lat, longitude: lng);
    result.fold((failure) => emit(AddressError(failure)), (location) {
      pickedLocation = location;
      emit(AddressLocationPicked(location, recenter: recenter));
    });
  }

  Future<void> addAddress(AddressEntity address) async {
    emit(AddressLoading());
    final result = await addAddressUseCase(address);
    result.fold(
      (failure) => emit(AddressError(failure)),
      (savedAddress) => emit(AddressLoaded(savedAddress)),
    );
  }

  Future<void> loadAddresses() async {
    emit(AddressLoading());
    final result = await getAddressesUseCase();
    result.fold(
      (failure) => emit(AddressError(failure)),
      (addresses) => emit(AddressListLoaded(addresses)),
    );
  }

  Future<void> deleteAddress(String id) async {
    final result = await deleteAddressUseCase(id);
    result.fold((failure) => emit(AddressError(failure)), (_) {
      emit(AddressDeleted());
      loadAddresses();
    });
  }

  Future<void> setDefault(String id) async {
    final result = await setDefaultAddressUseCase(id);
    result.fold(
      (failure) => emit(AddressError(failure)),
      (_) => loadAddresses(),
    );
  }

  // AddressCubit — add field + constructor param

  /// Debounced place search — call on every keystroke in the search field.
  void searchPlaces(String query) {
    _searchDebounce?.cancel();
    if (query.trim().isEmpty) {
      emit(AddressSearchLoaded(const []));
      return;
    }
    emit(AddressSearchLoading());
    _searchDebounce = Timer(const Duration(milliseconds: 1200), () async {
      final result = await searchPlacesUseCase(query);
      result.fold(
        (failure) => emit(AddressSearchError(failure.message)),
        (results) => emit(AddressSearchLoaded(results)),
      );
    });
  }

  /// Called when the user taps a search result — resolves it as the picked
  /// location and tells the map to recenter on it.
  Future<void> selectSearchResult(SearchResultEntity result) async {
    _lastCenter = LatLng(result.latitude, result.longitude);
    await _resolve(result.latitude, result.longitude, recenter: true);
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    _searchDebounce?.cancel();
    return super.close();
  }
}
