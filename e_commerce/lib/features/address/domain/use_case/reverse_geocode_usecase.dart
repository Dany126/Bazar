import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/address/domain/entity/picked_location_entity.dart';
import 'package:e_commerce/features/address/domain/repo/address_repo.dart';
import 'package:dartz/dartz.dart';

class ReverseGeocodeUseCase {
  final AddressRepo addressRepo;
  ReverseGeocodeUseCase(this.addressRepo);

  Future<Either<Failure, PickedLocationEntity>> call({
    required double latitude,
    required double longitude,
  }) {
    return addressRepo.reverseGeocode(latitude: latitude, longitude: longitude);
  }
}
