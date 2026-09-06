import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/auth/data/auth_data_source/auth_local_data_source.dart';
import 'package:e_commerce/features/auth/domain/entity/user_entity.dart';
import 'package:e_commerce/features/profile/domain/data_source/profile_remote_data_source.dart';
import 'package:e_commerce/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required String name,
    required String email,
    required String phone,
    File? image,
  }) async {
    final result = await remoteDataSource.updateProfile(
      name: name,
      email: email,
      phone: phone,
      image: image,
    );

    return result.fold((failure) => Left(failure), (updatedUser) async {
      final cacheResult = await localDataSource.cacheUser(updatedUser);

      return cacheResult.fold(
        (failure) => Left(failure),
        (_) => Right(updatedUser),
      );
    });
  }

  @override
  Either<Failure, UserEntity> getCachedUser() {
    return localDataSource.getCachedUser();
  }
}
