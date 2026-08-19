import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/address/domain/entity/address_entity.dart';
import 'package:e_commerce/features/address/domain/repo/address_repo.dart';

class EditAddressUseCase {
  final AddressRepo addressRepo;
  EditAddressUseCase(this.addressRepo);

  Future<Either<Failure, AddressEntity>> call(AddressEntity address) {
    return addressRepo.editAddress(address);
  }
}
