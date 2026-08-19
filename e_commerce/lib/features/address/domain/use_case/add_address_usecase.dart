import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/address/domain/entity/address_entity.dart';
import 'package:e_commerce/features/address/domain/repo/address_repo.dart';
import 'package:dartz/dartz.dart';


class AddAddressUseCase {
  final AddressRepo addressRepo;
  AddAddressUseCase(this.addressRepo);

  Future<Either<Failure, AddressEntity>> call(AddressEntity address) {
    return addressRepo.addAddress(address);
  }
}
