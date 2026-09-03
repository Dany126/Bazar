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

    final store = Map<String, dynamic>.from(json['store'] as Map? ?? {});

    double numValue(dynamic value) {
      if (value is num) {
        return value.toDouble();
      }

      return double.tryParse('$value') ?? 0;
    }

    int intValue(dynamic value) {
      if (value is num) {
        return value.toInt();
      }

      return int.tryParse('$value') ?? 0;
    }

    double? nullableNum(dynamic value) {
      if (value == null) {
        return null;
      }

      return numValue(value);
    }

    DateTime? date(dynamic value) {
      if (value == null) {
        return null;
      }

      return DateTime.tryParse('$value');
    }

    return AdminDashboardData(
      period: '${json['period'] ?? 'month'}',

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

      store: AdminDashboardStore(
        name: '${store['name'] ?? 'Bazar'}',
        currency: '${store['currency'] ?? 'EGP'}',
        storeEnabled: store['storeEnabled'] == true,
        acceptOrders: store['acceptOrders'] == true,
        lowStockThreshold: intValue(store['lowStockThreshold']),
      ),

      categoryBreakdown: ((json['categoryBreakdown'] as List?) ?? [])
          .whereType<Map>()
          .map(
            (item) => AdminCategoryBreakdown(
              name: '${item['name'] ?? ''}',
              count: intValue(item['count']),
              percent: numValue(item['percent']),
            ),
          )
          .toList(),

      revenueChart: ((json['revenueChart'] as List?) ?? [])
          .whereType<Map>()
          .map(
            (item) => AdminRevenuePoint(
              label: '${item['label'] ?? item['period'] ?? ''}',
              revenue: numValue(item['revenue']),
            ),
          )
          .toList(),

      recentOrders: ((json['recentOrders'] as List?) ?? [])
          .whereType<Map>()
          .map(
            (item) => AdminRecentOrder(
              id: '${item['id'] ?? ''}',
              customer: '${item['customer'] ?? 'Guest'}',
              total: numValue(item['total']),
              status: '${item['status'] ?? ''}',
              paymentStatus: '${item['paymentStatus'] ?? ''}',
              createdAt: date(item['createdAt']),
            ),
          )
          .toList(),

      lowInventory: ((json['lowInventory'] as List?) ?? [])
          .whereType<Map>()
          .map(
            (item) => AdminInventoryItem(
              name: '${item['name'] ?? ''}',
              size: item['size']?.toString(),
              color: item['color']?.toString(),
              count: intValue(item['stock']),
            ),
          )
          .toList(),
    );
  }
}
