import 'package:e_commerce/features/admin/domain/entity/admin_store_settings.dart';

abstract class AdminStoreSettingsState {
  const AdminStoreSettingsState();
}

class AdminStoreSettingsInitial extends AdminStoreSettingsState {
  const AdminStoreSettingsInitial();
}

class AdminStoreSettingsLoading extends AdminStoreSettingsState {
  const AdminStoreSettingsLoading();
}

class AdminStoreSettingsLoaded extends AdminStoreSettingsState {
  final AdminStoreSettings settings;
  final bool saving;

  const AdminStoreSettingsLoaded({required this.settings, this.saving = false});

  AdminStoreSettingsLoaded copyWith({
    AdminStoreSettings? settings,
    bool? saving,
  }) {
    return AdminStoreSettingsLoaded(
      settings: settings ?? this.settings,
      saving: saving ?? this.saving,
    );
  }
}

class AdminStoreSettingsFailure extends AdminStoreSettingsState {
  final String message;

  const AdminStoreSettingsFailure(this.message);
}

class AdminStoreSettingsSaved extends AdminStoreSettingsState {
  final AdminStoreSettings settings;

  const AdminStoreSettingsSaved({required this.settings});
}
