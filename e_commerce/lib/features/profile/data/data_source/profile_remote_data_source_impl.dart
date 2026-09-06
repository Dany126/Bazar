import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/auth/data/model/user_model.dart';
import 'package:e_commerce/features/profile/domain/data_source/profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService apiService;

  ProfileRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<Failure, UserModel>> updateProfile({
    required String name,
    required String email,
    required String phone,
    File? image,
  }) async {
    try {
      final Map<String, dynamic> fields = {
        'name': name,
        'email': email,
        'phone': phone,
      };

      if (image != null) {
        fields['image'] = await MultipartFile.fromFile(
          image.path,
          filename: image.path.split(Platform.pathSeparator).last,
        );
      }

      final formData = FormData.fromMap(fields);

      final result = await apiService.patch('/user/profile', data: formData);

      return await result.fold((failure) => Left(failure), (data) {
        try {
          if (data is! Map) {
            return Left(
              ServerFailure(message: 'Invalid profile update response'),
            );
          }

          final rawUser = data['user'];

          if (rawUser is! Map) {
            return Left(
              ServerFailure(message: 'Updated user was not returned by server'),
            );
          }

          final user = UserModel.fromJson(Map<String, dynamic>.from(rawUser));

          return Right(user);
        } catch (e) {
          return Left(
            ServerFailure(message: 'Failed to parse updated user: $e'),
          );
        }
      });
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update profile: $e'));
    }
  }
}
