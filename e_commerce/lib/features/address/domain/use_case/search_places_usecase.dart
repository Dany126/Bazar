import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import '../entity/search_result_entity.dart';
import '../repo/address_repo.dart';

class SearchPlacesUseCase {
  final AddressRepo addressRepo;
  SearchPlacesUseCase(this.addressRepo);

  Future<Either<Failure, List<SearchResultEntity>>> call(String query) {
    return addressRepo.searchPlaces(query);
  }
}
