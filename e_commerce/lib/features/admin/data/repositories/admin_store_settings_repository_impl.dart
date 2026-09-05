import 'package:dartz/dartz.dart';

import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/data/datasources/admin_store_settings_remote_data_source.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_store_settings.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_store_settings_repository.dart';

class AdminStoreSettingsRepositoryImpl implements AdminStoreSettingsRepository {
  final AdminStoreSettingsRemoteDataSource remoteDataSource;

  AdminStoreSettingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AdminStoreSettings>> getStoreSettings() {
    return remoteDataSource.getStoreSettings();
  }

  @override
  Future<Either<Failure, AdminStoreSettings>> updateStoreSettings({
    required AdminStoreSettings settings,
  }) {
    return remoteDataSource.updateStoreSettings(settings: settings);
  }
}
