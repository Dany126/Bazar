// lib/features/address/data/repo/address_repo_impl.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/address/domain/data_source/address_remote_data_source.dart';
import 'package:e_commerce/features/address/domain/entity/address_entity.dart';
import 'package:e_commerce/features/address/domain/repo/address_repo.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddresses() =>
      remoteDataSource.getAddresses();

  @override
  Future<Either<Failure, AddressEntity>> addAddress({
    required String street,
    required String city,
    required String country,
    required String postalCode,
  }) {
    return remoteDataSource.addAddress(
      street: street,
      city: city,
      country: country,
      postalCode: postalCode,
    );
  }

  @override
  Future<Either<Failure, void>> deleteAddress({required String addressId}) =>
      remoteDataSource.deleteAddress(addressId: addressId);
}
