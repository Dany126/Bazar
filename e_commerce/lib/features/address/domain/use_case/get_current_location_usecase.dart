import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/address/domain/repo/address_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

class GetCurrentLocationUseCase {
  final AddressRepo addressRepo;
  GetCurrentLocationUseCase(this.addressRepo);

  Future<Either<Failure, Position>> call() {
    return addressRepo.getCurrentLocation();
  }
}
