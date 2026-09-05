import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_store_settings.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_store_settings_repository.dart';

class UpdateAdminStoreSettingsUseCase {
  final AdminStoreSettingsRepository repository;

  UpdateAdminStoreSettingsUseCase({required this.repository});

  Future<Either<Failure, AdminStoreSettings>> call({
    required AdminStoreSettings settings,
  }) {
    return repository.updateStoreSettings(settings: settings);
  }
}
