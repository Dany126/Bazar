import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';

abstract class AdminEarningsState {
  const AdminEarningsState();
}

class AdminEarningsInitial
    extends AdminEarningsState {
  const AdminEarningsInitial();
}

class AdminEarningsLoading
    extends AdminEarningsState {
  const AdminEarningsLoading();
}

class AdminEarningsLoaded
    extends AdminEarningsState {
  final AdminDashboardData data;

  const AdminEarningsLoaded(
    this.data,
  );
}

class AdminEarningsFailure
    extends AdminEarningsState {
  final String message;

  const AdminEarningsFailure(
    this.message,
  );
}