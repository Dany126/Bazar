// lib/features/address/domin/use_case/get_addresses_use_case.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/address/domain/entity/address_entity.dart';
import 'package:e_commerce/features/address/domain/repo/address_repo.dart';

class GetAddressesUseCase {
  final AddressRepository repository;
  GetAddressesUseCase(this.repository);

  Future<Either<Failure, List<AddressEntity>>> call() =>
      repository.getAddresses();
}
