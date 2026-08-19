import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/address/domain/repo/address_repo.dart';

class SetDefaultAddressUseCase {
  final AddressRepo addressRepo;
  SetDefaultAddressUseCase(this.addressRepo);

  Future<Either<Failure, Unit>> call(String addressId) {
    return addressRepo.setDefaultAddress(addressId);
  }
}
