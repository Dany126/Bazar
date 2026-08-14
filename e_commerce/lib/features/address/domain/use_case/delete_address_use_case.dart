// lib/features/address/domin/use_case/delete_address_use_case.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/address/domain/repo/address_repo.dart';

class DeleteAddressUseCase {
  final AddressRepository repository;
  DeleteAddressUseCase(this.repository);

  Future<Either<Failure, void>> call({required String addressId}) {
    return repository.deleteAddress(addressId: addressId);
  }
}
