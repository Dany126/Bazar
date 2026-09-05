import 'package:dartz/dartz.dart';

import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_store_settings.dart';

abstract class AdminStoreSettingsRemoteDataSource {
  Future<Either<Failure, AdminStoreSettings>> getStoreSettings();

  Future<Either<Failure, AdminStoreSettings>> updateStoreSettings({
    required AdminStoreSettings settings,
  });
}

class AdminStoreSettingsRemoteDataSourceImpl
    implements AdminStoreSettingsRemoteDataSource {
  final ApiService apiService;

  AdminStoreSettingsRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<Failure, AdminStoreSettings>> getStoreSettings() async {
    print('');
    print('==============================================');
    print('GET ADMIN STORE SETTINGS');
    print('==============================================');

    final result = await apiService.get('$kBaseUrl/admin/settings');

    return result.fold(
      (failure) {
        print('GET SETTINGS ERROR:');
        print(failure.message);

        return Left(failure);
      },
      (json) {
        print('GET SETTINGS RESPONSE:');
        print(json);

        try {
          if (json is! Map) {
            return Left(
              ServerFailure(message: 'Invalid store settings response'),
            );
          }

          final rawSettings = json['settings'];

          if (rawSettings is! Map) {
            return Left(ServerFailure(message: 'Store settings not found'));
          }

          return Right(
            AdminStoreSettings.fromJson(Map<String, dynamic>.from(rawSettings)),
          );
        } catch (e) {
          return Left(ServerFailure(message: 'Invalid store settings: $e'));
        }
      },
    );
  }

  @override
  Future<Either<Failure, AdminStoreSettings>> updateStoreSettings({
    required AdminStoreSettings settings,
  }) async {
    final data = settings.toJson();

    print('');
    print('==============================================');
    print('PATCH ADMIN STORE SETTINGS');
    print('==============================================');
    print('URL:');
    print('$kBaseUrl/admin/settings');
    print('');
    print('REQUEST BODY:');
    print(data);
    print('==============================================');

    final result = await apiService.patch(
      '$kBaseUrl/admin/settings',
      data: data,
    );

    return result.fold(
      (failure) {
        print('');
        print('==============================================');
        print('PATCH SETTINGS ERROR');
        print('==============================================');
        print(failure.message);
        print('==============================================');

        return Left(failure);
      },
      (json) {
        print('');
        print('==============================================');
        print('PATCH SETTINGS RESPONSE');
        print('==============================================');
        print(json);
        print('==============================================');

        try {
          if (json is! Map) {
            return Left(ServerFailure(message: 'Invalid update response'));
          }

          final rawSettings = json['settings'];

          if (rawSettings is! Map) {
            return Left(ServerFailure(message: 'Updated settings not found'));
          }

          final updatedSettings = AdminStoreSettings.fromJson(
            Map<String, dynamic>.from(rawSettings),
          );

          return Right(updatedSettings);
        } catch (e) {
          return Left(ServerFailure(message: 'Invalid updated settings: $e'));
        }
      },
    );
  }
}
