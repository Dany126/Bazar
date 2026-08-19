import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/address/domain/repo/address_repo.dart';


class DeleteAddressUseCase {
  final AddressRepo addressRepo;
  DeleteAddressUseCase(this.addressRepo);

  Future<Either<Failure, Unit>> call(String addressId) {
    return addressRepo.deleteAddress(addressId);
  }
}
