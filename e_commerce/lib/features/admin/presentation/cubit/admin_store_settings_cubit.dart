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
        emit(AdminStoreSettingsLoaded(settings: settings));
      },
    );
  }

  Future<void> updateSettings(AdminStoreSettings settings) async {
    final currentState = state;

    if (currentState is AdminStoreSettingsLoaded) {
      emit(currentState.copyWith(saving: true));
    }

    final result = await updateStoreSettingsUseCase(settings: settings);

    result.fold(
      (failure) {
        if (currentState is AdminStoreSettingsLoaded) {
          emit(currentState.copyWith(saving: false));
        }

        emit(AdminStoreSettingsFailure(failure.message));

        if (currentState is AdminStoreSettingsLoaded) {
          emit(currentState);
        }
      },
      (updatedSettings) {
        emit(AdminStoreSettingsSaved(settings: updatedSettings));

        emit(AdminStoreSettingsLoaded(settings: updatedSettings));
      },
    );
  }
}
