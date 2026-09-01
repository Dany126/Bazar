import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';

abstract class AdminDashboardState {
  const AdminDashboardState();
}

class AdminDashboardInitial extends AdminDashboardState {}

class AdminDashboardLoading extends AdminDashboardState {}

class AdminDashboardLoaded extends AdminDashboardState {
  final AdminDashboardData data;

  const AdminDashboardLoaded(this.data);
}

class AdminDashboardFailure extends AdminDashboardState {
  final String message;

  const AdminDashboardFailure(this.message);
}
