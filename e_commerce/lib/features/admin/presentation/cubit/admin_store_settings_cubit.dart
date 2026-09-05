import 'package:e_commerce/features/admin/domain/entity/admin_store_settings.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_admin_store_settings.dart';
import 'package:e_commerce/features/admin/domain/usecases/update_admin_store_settings.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_store_settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminStoreSettingsCubit extends Cubit<AdminStoreSettingsState> {
  final GetAdminStoreSettingsUseCase getStoreSettingsUseCase;
  final UpdateAdminStoreSettingsUseCase updateStoreSettingsUseCase;

  AdminStoreSettingsCubit({
    required this.getStoreSettingsUseCase,
    required this.updateStoreSettingsUseCase,
  }) : super(const AdminStoreSettingsInitial());

  Future<void> loadSettings() async {
    emit(const AdminStoreSettingsLoading());

    final result = await getStoreSettingsUseCase();

    result.fold(
      (failure) {
        emit(AdminStoreSettingsFailure(failure.message));
      },
      (settings) {
        emit(AdminStoreSettingsLoaded(settings: settings, saving: false));
      },
    );
  }

  Future<void> updateSettings(AdminStoreSettings settings) async {
    final oldState = state;

    AdminStoreSettings? oldSettings;

    if (oldState is AdminStoreSettingsLoaded) {
      oldSettings = oldState.settings;

      emit(AdminStoreSettingsLoaded(settings: oldState.settings, saving: true));
    }

    print('');
    print('==============================================');
    print('ADMIN STORE SETTINGS - SAVE');
    print('==============================================');
    print('DATA BEING SENT:');
    print(settings.toJson());
    print('==============================================');

    final result = await updateStoreSettingsUseCase(settings: settings);

    result.fold(
      (failure) {
        print('');
        print('==============================================');
        print('ADMIN STORE SETTINGS - SAVE FAILED');
        print('==============================================');
        print(failure.message);
        print('==============================================');

        if (oldSettings != null) {
          emit(AdminStoreSettingsLoaded(settings: oldSettings, saving: false));
        } else {
          emit(AdminStoreSettingsFailure(failure.message));
        }
      },
      (updatedSettings) {
        print('');
        print('==============================================');
        print('ADMIN STORE SETTINGS - SAVE SUCCESS');
        print('==============================================');
        print('SERVER RETURNED:');
        print(updatedSettings.toJson());
        print('==============================================');

        emit(AdminStoreSettingsSaved(settings: updatedSettings));

        emit(
          AdminStoreSettingsLoaded(settings: updatedSettings, saving: false),
        );
      },
    );
  }
}
