import 'package:dartz/dartz.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';

abstract class AdminDashboardRemoteDataSource {
  Future<Either<Failure, AdminDashboardData>> getDashboardData({
    String period = 'month',
  });
}

class AdminDashboardRemoteDataSourceImpl
    implements AdminDashboardRemoteDataSource {
  final ApiService apiService;
  AdminDashboardRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<Failure, AdminDashboardData>> getDashboardData({
    String period = 'month',
  }) async {
    final result = await apiService.get(
      '$kBaseUrl/admin/dashboard?period=$period',
    );
    return result.fold((failure) => Left(failure), (json) {
      final raw = json['dashboard'];
      if (raw is! Map) {
        return Left(ServerFailure(message: 'Invalid dashboard response'));
      }
      try {
        return Right(_fromJson(Map<String, dynamic>.from(raw)));
      } catch (e) {
        return Left(ServerFailure(message: 'Invalid dashboard data: $e'));
      }
    });
  }

  AdminDashboardData _fromJson(Map<String, dynamic> json) {
    final stats = Map<String, dynamic>.from(json['stats'] as Map? ?? {});
    final changes = Map<String, dynamic>.from(stats['changes'] as Map? ?? {});

    double numValue(dynamic v) =>
        v is num ? v.toDouble() : double.tryParse('$v') ?? 0;
    int intValue(dynamic v) => v is num ? v.toInt() : int.tryParse('$v') ?? 0;
    double? nullableNum(dynamic v) => v == null ? null : numValue(v);

    DateTime? date(dynamic v) => v == null ? null : DateTime.tryParse('$v');

    return AdminDashboardData(
      period: '${json['period'] ?? ''}',
      totalRevenue: numValue(stats['totalRevenue']),
      periodRevenue: numValue(stats['periodRevenue']),
      totalOrders: intValue(stats['totalOrders']),
      periodOrders: intValue(stats['periodOrders']),
      totalProducts: intValue(stats['totalProducts']),
      totalCategories: intValue(stats['totalCategories']),
      totalUsers: intValue(stats['totalUsers']),
      totalVisitors: intValue(stats['totalVisitors']),
      conversionRate: nullableNum(stats['conversionRate']),
      lowStockAlerts: intValue(stats['lowStockAlerts']),
      changes: AdminDashboardChanges(
        revenue: nullableNum(changes['revenue']),
        orders: nullableNum(changes['orders']),
        visitors: nullableNum(changes['visitors']),
        conversionRate: nullableNum(changes['conversionRate']),
      ),
      categoryBreakdown: ((json['categoryBreakdown'] as List?) ?? [])
          .whereType<Map>()
          .map(
            (e) => AdminCategoryBreakdown(
              name: '${e['name'] ?? ''}',
              count: intValue(e['count']),
              percent: numValue(e['percent']),
            ),
          )
          .toList(),
      revenueChart: ((json['revenueChart'] as List?) ?? [])
          .whereType<Map>()
          .map(
            (e) => AdminRevenuePoint(
              label: '${e['label'] ?? e['period'] ?? ''}',
              revenue: numValue(e['revenue']),
            ),
          )
          .toList(),
      recentOrders: ((json['recentOrders'] as List?) ?? [])
          .whereType<Map>()
          .map(
            (e) => AdminRecentOrder(
              id: '${e['id'] ?? ''}',
              customer: '${e['customer'] ?? ''}',
              total: numValue(e['total']),
              status: '${e['status'] ?? ''}',
              paymentStatus: '${e['paymentStatus'] ?? ''}',
              createdAt: date(e['createdAt']),
            ),
          )
          .toList(),
      lowInventory: ((json['lowInventory'] as List?) ?? [])
          .whereType<Map>()
          .map(
            (e) => AdminInventoryItem(
              name: '${e['name'] ?? ''}',
              size: e['size']?.toString(),
              color: e['color']?.toString(),
              count: intValue(e['stock']),
            ),
          )
          .toList(),
    );
  }
}
