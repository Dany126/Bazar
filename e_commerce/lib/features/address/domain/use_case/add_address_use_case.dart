// lib/features/address/domin/use_case/add_address_use_case.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/address/domain/entity/address_entity.dart';
import 'package:e_commerce/features/address/domain/repo/address_repo.dart';

class AddAddressUseCase {
  final AddressRepository repository;
  AddAddressUseCase(this.repository);

  Future<Either<Failure, AddressEntity>> call({
    required String street,
    required String city,
    required String country,
    required String postalCode,
  }) {
    return repository.addAddress(
      street: street,
      city: city,
      country: country,
      postalCode: postalCode,
    );
  }
}
