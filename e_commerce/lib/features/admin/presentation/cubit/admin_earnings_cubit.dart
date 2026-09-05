import 'package:e_commerce/features/admin/domain/usecases/get_admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_earnings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminEarningsCubit
    extends Cubit<AdminEarningsState> {
  final GetAdminDashboardDataUseCase
      getDashboardData;

  AdminEarningsCubit({
    required this.getDashboardData,
  }) : super(
          const AdminEarningsInitial(),
        );

  Future<void> loadEarnings({
    String period = 'month',
  }) async {
    emit(
      const AdminEarningsLoading(),
    );

    final result =
        await getDashboardData(
      period: period,
    );

    result.fold(
      (failure) {
        emit(
          AdminEarningsFailure(
            failure.message,
          ),
        );
      },
      (data) {
        emit(
          AdminEarningsLoaded(data),
        );
      },
    );
  }
}