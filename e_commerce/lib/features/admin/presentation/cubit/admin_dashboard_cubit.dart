import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  final GetAdminDashboardDataUseCase getAdminDashboardDataUseCase;

  AdminDashboardCubit({required this.getAdminDashboardDataUseCase})
    : super(AdminDashboardInitial());

  Future<void> loadDashboard({String period = 'month'}) async {
    emit(AdminDashboardLoading());

    final Either<Failure, AdminDashboardData> result =
        await getAdminDashboardDataUseCase.call(period: period);

    result.fold(
      (failure) => emit(AdminDashboardFailure(failure.message)),
      (data) => emit(AdminDashboardLoaded(data)),
    );
  }
}
