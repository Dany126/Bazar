import 'package:dartz/dartz.dart';

import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_store_settings.dart';

abstract class AdminStoreSettingsRepository {
  Future<Either<Failure, AdminStoreSettings>> getStoreSettings();

  Future<Either<Failure, AdminStoreSettings>> updateStoreSettings({
    required AdminStoreSettings settings,
  });
}
