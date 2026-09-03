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
      try {
        if (json is! Map) {
          return Left(ServerFailure(message: 'Invalid dashboard response'));
        }

        final response = Map<String, dynamic>.from(json);

        final raw = response['data'];

        if (raw is! Map) {
          return Left(ServerFailure(message: 'Dashboard data is missing'));
        }

        return Right(_parseDashboard(Map<String, dynamic>.from(raw)));
      } catch (e) {
        return Left(
          ServerFailure(message: 'Failed to parse dashboard data: $e'),
        );
      }
    });
  }

  AdminDashboardData _parseDashboard(Map<String, dynamic> json) {
    final revenue = _map(json['revenue']);

    final orders = _map(json['orders']);

    final products = _map(json['products']);

    final categories = _map(json['categories']);

    final customers = _map(json['customers']);

    final visitors = _map(json['visitors']);

    final conversion = _map(json['conversionRate']);

    final changes = _map(json['changes']);

    final store = _map(json['store']);

    final period = json['period']?.toString() ?? 'month';

    final revenueChart = _parseRevenueChart(json['revenueChart']);

    final categoryBreakdown = _parseCategories(json['categoryBreakdown']);

    final lowInventory = _parseInventory(json['lowInventory']);

    return AdminDashboardData(
      period: period,

      totalRevenue: _double(revenue['total']),

      periodRevenue: _double(revenue['total']),

      totalOrders: _int(orders['total']),

      periodOrders: _int(orders['total']),

      totalProducts: _int(products['total']),

      totalCategories: _int(categories['total']),

      totalUsers: _int(customers['total']),

      totalVisitors: _int(visitors['total']),

      conversionRate: _nullableDouble(conversion['rate']),

      lowStockAlerts: _int(
        json['lowStockAlerts'],
        fallback: lowInventory.length,
      ),

      changes: AdminDashboardChanges(
        revenue: _nullableDouble(changes['revenue'] ?? revenue['change']),

        orders: _nullableDouble(changes['orders'] ?? orders['change']),

        visitors: _nullableDouble(changes['visitors'] ?? visitors['change']),

        conversionRate: _nullableDouble(
          changes['conversionRate'] ?? conversion['change'],
        ),
      ),

      store: AdminDashboardStore(
        name: store['name']?.toString() ?? store['storeName']?.toString() ?? '',

        currency: store['currency']?.toString() ?? 'EGP',

        storeEnabled: store['storeEnabled'] == true,

        acceptOrders: store['acceptOrders'] == true,

        lowStockThreshold: _int(
          json['lowStockThreshold'] ?? store['lowStockThreshold'],
        ),
      ),

      categoryBreakdown: categoryBreakdown,

      revenueChart: revenueChart,

      lowInventory: lowInventory,
    );
  }

  List<AdminCategoryBreakdown> _parseCategories(dynamic value) {
    if (value is! List) {
      return [];
    }

    return value.whereType<Map>().map((item) {
      final map = Map<String, dynamic>.from(item);

      return AdminCategoryBreakdown(
        id: map['categoryId']?.toString() ?? '',

        name:
            map['categoryName']?.toString() ??
            map['name']?.toString() ??
            'Uncategorized',

        orders: _int(map['orders']),

        quantity: _int(map['quantity']),

        revenue: _double(map['revenue']),

        percent: _double(map['percent']),
      );
    }).toList();
  }

  List<AdminRevenuePoint> _parseRevenueChart(dynamic value) {
    if (value is! List) {
      return [];
    }

    return value.whereType<Map>().map((item) {
      final map = Map<String, dynamic>.from(item);

      return AdminRevenuePoint(
        date: map['date']?.toString() ?? map['label']?.toString() ?? '',

        revenue: _double(map['revenue']),
      );
    }).toList();
  }

  List<AdminInventoryItem> _parseInventory(dynamic value) {
    if (value is! List) {
      return [];
    }

    return value.whereType<Map>().map((item) {
      final map = Map<String, dynamic>.from(item);

      return AdminInventoryItem(
        id: map['_id']?.toString() ?? map['id']?.toString() ?? '',

        productId: map['productId']?.toString() ?? '',

        name: map['name']?.toString() ?? '',

        size: map['size']?.toString(),

        color: map['color']?.toString(),

        count: _int(map['stock']),

        price: _double(map['price']),

        soldCount: _int(map['soldCount']),

        thumbnailUrl: map['thumbnailUrl']?.toString(),
      );
    }).toList();
  }

  Map<String, dynamic> _map(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return {};
  }

  double _double(dynamic value, {double fallback = 0}) {
    if (value is num) {
      return value.toDouble();
    }

    if (value == null) {
      return fallback;
    }

    return double.tryParse(value.toString()) ?? fallback;
  }

  double? _nullableDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }

  int _int(dynamic value, {int fallback = 0}) {
    if (value is num) {
      return value.toInt();
    }

    if (value == null) {
      return fallback;
    }

    return int.tryParse(value.toString()) ?? fallback;
  }
}
