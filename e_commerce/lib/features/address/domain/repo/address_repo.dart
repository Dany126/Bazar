import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/address/domain/entity/address_entity.dart';

abstract class AddressRepository {
  Future<Either<Failure, List<AddressEntity>>> getAddresses();

  Future<Either<Failure, AddressEntity>> addAddress({
    required String street,
    required String city,
    required String country,
    required String postalCode,
    bool isDefault = false,
  });

  Future<Either<Failure, void>> deleteAddress({required String addressId});
}
