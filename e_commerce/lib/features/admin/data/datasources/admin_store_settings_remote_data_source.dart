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
    final result = await apiService.get('$kBaseUrl/admin/settings');

    return result.fold((failure) => Left(failure), (json) {
      try {
        if (json is! Map) {
          return Left(
            ServerFailure(message: 'Invalid store settings response'),
          );
        }

        final raw = json['settings'];

        if (raw is! Map) {
          return Left(ServerFailure(message: 'Store settings not found'));
        }

        return Right(
          AdminStoreSettings.fromJson(Map<String, dynamic>.from(raw)),
        );
      } catch (e) {
        return Left(ServerFailure(message: 'Invalid store settings: $e'));
      }
    });
  }

  @override
  Future<Either<Failure, AdminStoreSettings>> updateStoreSettings({
    required AdminStoreSettings settings,
  }) async {
    final result = await apiService.patch(
      '$kBaseUrl/admin/settings',
      data: settings.toJson(),
    );

    return result.fold((failure) => Left(failure), (json) {
      try {
        if (json is! Map) {
          return Left(ServerFailure(message: 'Invalid update response'));
        }

        final raw = json['settings'];

        if (raw is! Map) {
          return Left(ServerFailure(message: 'Updated settings not found'));
        }

        return Right(
          AdminStoreSettings.fromJson(Map<String, dynamic>.from(raw)),
        );
      } catch (e) {
        return Left(ServerFailure(message: 'Invalid updated settings: $e'));
      }
    });
  }
}
