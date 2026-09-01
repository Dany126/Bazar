class AdminDashboardData {
  final double totalRevenue;
  final int totalOrders;
  final int totalProducts;
  final int totalCategories;
  final int totalVisitors;
  final double conversionRate;
  final List<AdminCategoryBreakdown> categoryBreakdown;
  final List<AdminRecentOrder> recentOrders;
  final List<AdminInventoryItem> lowInventory;
  final List<int> salesTrend;

  const AdminDashboardData({
    required this.totalRevenue,
    required this.totalOrders,
    required this.totalProducts,
    required this.totalCategories,
    required this.totalVisitors,
    required this.conversionRate,
    required this.categoryBreakdown,
    required this.recentOrders,
    required this.lowInventory,
    required this.salesTrend,
  });

  factory AdminDashboardData.empty() {
    return const AdminDashboardData(
      totalRevenue: 0,
      totalOrders: 0,
      totalProducts: 0,
      totalCategories: 0,
      totalVisitors: 0,
      conversionRate: 0,
      categoryBreakdown: [],
      recentOrders: [],
      lowInventory: [],
      salesTrend: [0, 0, 0, 0, 0, 0, 0],
    );
  }
}

class AdminCategoryBreakdown {
  final String name;
  final double percent;

  const AdminCategoryBreakdown({required this.name, required this.percent});
}

class AdminRecentOrder {
  final String id;
  final String customer;
  final double total;
  final String status;

  const AdminRecentOrder({
    required this.id,
    required this.customer,
    required this.total,
    required this.status,
  });
}

class AdminInventoryItem {
  final String name;
  final int count;

  const AdminInventoryItem({required this.name, required this.count});
}
