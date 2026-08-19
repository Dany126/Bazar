import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/address/domain/entity/address_entity.dart';
import 'package:e_commerce/features/address/domain/entity/picked_location_entity.dart';
import 'package:e_commerce/features/address/domain/entity/search_result_entity.dart';
import 'package:geolocator/geolocator.dart';

abstract class AddressRepo {
  Future<Either<Failure, Position>> getCurrentLocation();

  Future<Either<Failure, PickedLocationEntity>> reverseGeocode({
    required double latitude,
    required double longitude,
  });
  // address_repo.dart — add this method
  Future<Either<Failure, AddressEntity>> editAddress(AddressEntity address);
  Future<Either<Failure, List<SearchResultEntity>>> searchPlaces(String query);
  Future<Either<Failure, AddressEntity>> addAddress(AddressEntity address);

  Future<Either<Failure, List<AddressEntity>>> getAddresses();

  Future<Either<Failure, Unit>> deleteAddress(String addressId);

  Future<Either<Failure, Unit>> setDefaultAddress(String addressId);
}
