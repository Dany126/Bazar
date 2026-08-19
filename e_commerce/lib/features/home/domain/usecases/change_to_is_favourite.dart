import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/domain/repos/home_repo.dart';

class ChangeToIsFavourite {
  HomeRepo homeRepo;
  ChangeToIsFavourite({required this.homeRepo});

  Future<Either<Failure, Unit>> call({
    required String productId,
    required bool isFavourite,
  }) {
    return homeRepo.ChangeToIsFavourite(
      productId: productId,
      isFavourite: isFavourite,
    );
  }
}
