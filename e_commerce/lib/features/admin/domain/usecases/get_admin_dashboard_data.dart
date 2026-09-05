import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_dashboard_repository.dart';

class GetAdminDashboardDataUseCase {
  final AdminDashboardRepository repository;

  const GetAdminDashboardDataUseCase(this.repository);

  Future<Either<Failure, AdminDashboardData>> call({String period = 'month'}) {
    return repository.getDashboardData(period: period);
  }
}
