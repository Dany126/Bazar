import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/address/domain/entity/address_entity.dart';
import 'package:e_commerce/features/address/domain/repo/address_repo.dart';
import 'package:dartz/dartz.dart';

class GetAddressesUseCase {
  final AddressRepo addressRepo;
  GetAddressesUseCase(this.addressRepo);

  Future<Either<Failure, List<AddressEntity>>> call() {
    return addressRepo.getAddresses();
  }
}
