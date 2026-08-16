import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/address/data/model/address_model.dart';

abstract class AddressRemoteDataSource {
  Future<Either<Failure, List<AddressModel>>> getAddresses();

  Future<Either<Failure, AddressModel>> addAddress({
    required String street,
    required String city,
    required String country,
    required String postalCode,
    bool isDefault = false,
  });

  Future<Either<Failure, void>> deleteAddress({required String addressId});
}
