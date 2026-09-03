class AdminDashboardData {
  final String period;

  final double totalRevenue;
  final double periodRevenue;

  final int totalOrders;
  final int periodOrders;

  final int totalProducts;
  final int totalCategories;
  final int totalUsers;

  final int totalVisitors;

  final double? conversionRate;

  final int lowStockAlerts;

  final AdminDashboardChanges changes;

  final AdminDashboardStore store;

  final List<AdminCategoryBreakdown> categoryBreakdown;

  final List<AdminRevenuePoint> revenueChart;

  final List<AdminRecentOrder> recentOrders;

  final List<AdminInventoryItem> lowInventory;

  const AdminDashboardData({
    required this.period,
    required this.totalRevenue,
    required this.periodRevenue,
    required this.totalOrders,
    required this.periodOrders,
    required this.totalProducts,
    required this.totalCategories,
    required this.totalUsers,
    required this.totalVisitors,
    required this.conversionRate,
    required this.lowStockAlerts,
    required this.changes,
    required this.store,
    required this.categoryBreakdown,
    required this.revenueChart,
    required this.recentOrders,
    required this.lowInventory,
  });
}

class AdminDashboardStore {
  final String name;
  final String currency;
  final bool storeEnabled;
  final bool acceptOrders;
  final int lowStockThreshold;

  const AdminDashboardStore({
    required this.name,
    required this.currency,
    required this.storeEnabled,
    required this.acceptOrders,
    required this.lowStockThreshold,
  });
}

class AdminDashboardChanges {
  final double? revenue;
  final double? orders;
  final double? visitors;
  final double? conversionRate;

  const AdminDashboardChanges({
    this.revenue,
    this.orders,
    this.visitors,
    this.conversionRate,
  });
}

class AdminCategoryBreakdown {
  final String name;
  final int count;
  final double percent;

  const AdminCategoryBreakdown({
    required this.name,
    required this.count,
    required this.percent,
  });
}

class AdminRevenuePoint {
  final String label;
  final double revenue;

  const AdminRevenuePoint({required this.label, required this.revenue});
}

class AdminRecentOrder {
  final String id;
  final String customer;
  final double total;
  final String status;
  final String paymentStatus;
  final DateTime? createdAt;

  const AdminRecentOrder({
    required this.id,
    required this.customer,
    required this.total,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
  });
}

class AdminInventoryItem {
  final String name;
  final String? size;
  final String? color;
  final int count;

  const AdminInventoryItem({
    required this.name,
    this.size,
    this.color,
    required this.count,
  });
}
