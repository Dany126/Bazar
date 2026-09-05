import 'package:dartz/dartz.dart';

import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_store_settings.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_store_settings_repository.dart';

class GetAdminStoreSettingsUseCase {
  final AdminStoreSettingsRepository repository;

  GetAdminStoreSettingsUseCase({required this.repository});

  Future<Either<Failure, AdminStoreSettings>> call() {
    return repository.getStoreSettings();
  }
}
