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

        /*
          |--------------------------------------------------------------------------
          | Support both backend response formats
          |--------------------------------------------------------------------------
          |
          | Old:
          | {
          |   "status": "Success",
          |   "dashboard": {...}
          | }
          |
          | Current:
          | {
          |   "status": "Success",
          |   "data": {...}
          | }
          |
          */

        dynamic raw;

        if (response['dashboard'] is Map) {
          raw = response['dashboard'];
        } else if (response['data'] is Map) {
          raw = response['data'];
        }

        if (raw is! Map) {
          return Left(ServerFailure(message: 'Invalid dashboard response'));
        }

        final dashboard = Map<String, dynamic>.from(raw);

        return Right(_fromJson(dashboard));
      } catch (e) {
        return Left(ServerFailure(message: 'Invalid dashboard data: $e'));
      }
    });
  }

  AdminDashboardData _fromJson(Map<String, dynamic> json) {
    final stats = _map(json['stats']);

    final store = _map(json['store']);

    final changes = _map(stats['changes']);

    /*
    |--------------------------------------------------------------------------
    | Helpers
    |--------------------------------------------------------------------------
    */

    double numValue(dynamic value, {double fallback = 0}) {
      if (value is num) {
        return value.toDouble();
      }

      if (value == null) {
        return fallback;
      }

      return double.tryParse(value.toString()) ?? fallback;
    }

    int intValue(dynamic value, {int fallback = 0}) {
      if (value is num) {
        return value.toInt();
      }

      if (value == null) {
        return fallback;
      }

      return int.tryParse(value.toString()) ?? fallback;
    }

    double? nullableNum(dynamic value) {
      if (value == null) {
        return null;
      }

      if (value is num) {
        return value.toDouble();
      }

      return double.tryParse(value.toString());
    }

    DateTime? date(dynamic value) {
      if (value == null) {
        return null;
      }

      return DateTime.tryParse(value.toString());
    }

    /*
    |--------------------------------------------------------------------------
    | Revenue
    |--------------------------------------------------------------------------
    |
    | Supports:
    |
    | Old:
    | stats.totalRevenue
    | stats.periodRevenue
    |
    | New:
    | data.revenue.total
    | data.revenue.previous
    |
    */

    final revenueObject = _map(json['revenue']);

    final totalRevenue = stats.containsKey('totalRevenue')
        ? numValue(stats['totalRevenue'])
        : numValue(revenueObject['total']);

    final periodRevenue = stats.containsKey('periodRevenue')
        ? numValue(stats['periodRevenue'])
        : numValue(revenueObject['total']);

    /*
    |--------------------------------------------------------------------------
    | Orders
    |--------------------------------------------------------------------------
    */

    final ordersObject = _map(json['orders']);

    final totalOrders = stats.containsKey('totalOrders')
        ? intValue(stats['totalOrders'])
        : intValue(ordersObject['total']);

    final periodOrders = stats.containsKey('periodOrders')
        ? intValue(stats['periodOrders'])
        : intValue(ordersObject['total']);

    /*
    |--------------------------------------------------------------------------
    | Products
    |--------------------------------------------------------------------------
    */

    final productsObject = _map(json['products']);

    final totalProducts = stats.containsKey('totalProducts')
        ? intValue(stats['totalProducts'])
        : intValue(productsObject['total']);

    /*
    |--------------------------------------------------------------------------
    | Categories
    |--------------------------------------------------------------------------
    */

    final categoriesObject = _map(json['categories']);

    final totalCategories = stats.containsKey('totalCategories')
        ? intValue(stats['totalCategories'])
        : intValue(categoriesObject['total']);

    /*
    |--------------------------------------------------------------------------
    | Customers / Users
    |--------------------------------------------------------------------------
    */

    final customersObject = _map(json['customers']);

    final totalUsers = stats.containsKey('totalUsers')
        ? intValue(stats['totalUsers'])
        : intValue(customersObject['total']);

    /*
    |--------------------------------------------------------------------------
    | Visitors
    |--------------------------------------------------------------------------
    */

    final visitorsObject = _map(json['visitors']);

    final totalVisitors = stats.containsKey('totalVisitors')
        ? intValue(stats['totalVisitors'])
        : intValue(visitorsObject['total']);

    /*
    |--------------------------------------------------------------------------
    | Conversion rate
    |--------------------------------------------------------------------------
    */

    final conversionObject = _map(json['conversionRate']);

    final conversionRate = stats.containsKey('conversionRate')
        ? nullableNum(stats['conversionRate'])
        : nullableNum(conversionObject['rate']);

    /*
    |--------------------------------------------------------------------------
    | Low stock
    |--------------------------------------------------------------------------
    */

    final lowInventoryRaw = (json['lowInventory'] as List?) ?? const [];

    /*
    |--------------------------------------------------------------------------
    | Category breakdown
    |--------------------------------------------------------------------------
    */

    final categoryRaw = (json['categoryBreakdown'] as List?) ?? const [];

    final categoryBreakdown = categoryRaw.whereType<Map>().map((item) {
      final map = Map<String, dynamic>.from(item);

      /*
                | Old backend:
                | name
                | count
                | percent
                |
                | New backend:
                | categoryName
                | orders
                */

      final name = map['name'] ?? map['categoryName'] ?? 'Uncategorized';

      final count = map.containsKey('count')
          ? intValue(map['count'])
          : intValue(map['orders']);

      final percent = map.containsKey('percent') ? numValue(map['percent']) : 0;

      return AdminCategoryBreakdown(
        name: name.toString(),
        count: count,
        percent: percent,
      );
    }).toList();

    /*
    |--------------------------------------------------------------------------
    | Revenue chart
    |--------------------------------------------------------------------------
    */

    final revenueChartRaw = (json['revenueChart'] as List?) ?? const [];

    final revenueChart = revenueChartRaw.whereType<Map>().map((item) {
      final map = Map<String, dynamic>.from(item);

      return AdminRevenuePoint(
        label: '${map['label'] ?? map['period'] ?? ''}',
        revenue: numValue(map['revenue']),
      );
    }).toList();

    /*
    |--------------------------------------------------------------------------
    | Recent orders
    |--------------------------------------------------------------------------
    |
    | Kept for compatibility with the entity.
    | Your dashboard UI can simply not display them.
    |
    */

    final recentOrdersRaw = (json['recentOrders'] as List?) ?? const [];

    final recentOrders = recentOrdersRaw.whereType<Map>().map((item) {
      final map = Map<String, dynamic>.from(item);

      return AdminRecentOrder(
        id: '${map['id'] ?? ''}',

        customer: '${map['customer'] ?? 'Guest'}',

        total: numValue(map['total']),

        status: '${map['status'] ?? ''}',

        paymentStatus: '${map['paymentStatus'] ?? ''}',

        createdAt: date(map['createdAt']),
      );
    }).toList();

    /*
    |--------------------------------------------------------------------------
    | Low inventory
    |--------------------------------------------------------------------------
    */

    final lowInventory = lowInventoryRaw.whereType<Map>().map((item) {
      final map = Map<String, dynamic>.from(item);

      return AdminInventoryItem(
        name: '${map['name'] ?? ''}',

        size: map['size']?.toString(),

        color: map['color']?.toString(),

        count: intValue(map['stock']),
      );
    }).toList();

    /*
    |--------------------------------------------------------------------------
    | Store
    |--------------------------------------------------------------------------
    */

    final storeName = store['name'] ?? store['storeName'] ?? 'Bazar';

    final currency = store['currency'] ?? 'EGP';

    final storeEnabled = store['storeEnabled'] == true;

    final acceptOrders = store['acceptOrders'] == true;

    final lowStockThreshold = intValue(store['lowStockThreshold']);

    /*
    |--------------------------------------------------------------------------
    | Return dashboard entity
    |--------------------------------------------------------------------------
    */

    return AdminDashboardData(
      period: '${json['period'] ?? 'month'}',

      totalRevenue: totalRevenue,

      periodRevenue: periodRevenue,

      totalOrders: totalOrders,

      periodOrders: periodOrders,

      totalProducts: totalProducts,

      totalCategories: totalCategories,

      totalUsers: totalUsers,

      totalVisitors: totalVisitors,

      conversionRate: conversionRate,

      lowStockAlerts: stats.containsKey('lowStockAlerts')
          ? intValue(stats['lowStockAlerts'])
          : lowInventory.length,

      changes: AdminDashboardChanges(
        revenue: _nullableChange(changes['revenue'], revenueObject['change']),

        orders: _nullableChange(changes['orders'], ordersObject['change']),

        visitors: _nullableChange(
          changes['visitors'],
          visitorsObject['change'],
        ),

        conversionRate: _nullableChange(
          changes['conversionRate'],
          conversionObject['change'],
        ),
      ),

      store: AdminDashboardStore(
        name: storeName.toString(),

        currency: currency.toString(),

        storeEnabled: storeEnabled,

        acceptOrders: acceptOrders,

        lowStockThreshold: lowStockThreshold,
      ),

      categoryBreakdown: categoryBreakdown,

      revenueChart: revenueChart,

      recentOrders: recentOrders,

      lowInventory: lowInventory,
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Map helper
  |--------------------------------------------------------------------------
  */

  Map<String, dynamic> _map(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }

  /*
  |--------------------------------------------------------------------------
  | Nullable change helper
  |--------------------------------------------------------------------------
  */

  double? _nullableChange(dynamic primary, dynamic fallback) {
    if (primary != null) {
      if (primary is num) {
        return primary.toDouble();
      }

      return double.tryParse(primary.toString());
    }

    if (fallback != null) {
      if (fallback is num) {
        return fallback.toDouble();
      }

      return double.tryParse(fallback.toString());
    }

    return null;
  }
}
