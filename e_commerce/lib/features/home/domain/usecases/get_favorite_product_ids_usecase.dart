import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/domain/repos/home_repo.dart';

class GetFavoriteProductIdsUseCase {
  final HomeRepo homeRepo;

  GetFavoriteProductIdsUseCase({required this.homeRepo});

  Future<Either<Failure, Set<String>>> call() {
    return homeRepo.getFavoriteProductIds();
  }
}
