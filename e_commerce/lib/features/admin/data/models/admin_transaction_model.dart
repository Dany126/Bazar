class AdminTransactionCustomer {
  final String id;
  final String name;
  final String email;
  final String phone;

  const AdminTransactionCustomer({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
  });

  factory AdminTransactionCustomer.fromJson(Map<String, dynamic> json) {
    return AdminTransactionCustomer(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }
}

class AdminTransactionModel {
  final String id;
  final String orderId;
  final AdminTransactionCustomer? customer;
  final double amount;
  final String paymentMethod;
  final String paymentStatus;
  final String transactionStatus;
  final String orderStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AdminTransactionModel({
    required this.id,
    required this.orderId,
    required this.customer,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.transactionStatus,
    required this.orderStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminTransactionModel.fromJson(Map<String, dynamic> json) {
    return AdminTransactionModel(
      id: json['id']?.toString() ?? '',
      orderId: json['orderId']?.toString() ?? '',
      customer: json['customer'] is Map
          ? AdminTransactionCustomer.fromJson(
              Map<String, dynamic>.from(json['customer'] as Map),
            )
          : null,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      paymentStatus: json['paymentStatus']?.toString() ?? '',
      transactionStatus: json['transactionStatus']?.toString() ?? '',
      orderStatus: json['orderStatus']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
    );
  }
}

class AdminTransactionSummary {
  final double totalAmount;
  final double paidAmount;
  final double pendingAmount;
  final double failedAmount;

  final int completedCount;
  final int pendingCount;
  final int failedCount;

  const AdminTransactionSummary({
    required this.totalAmount,
    required this.paidAmount,
    required this.pendingAmount,
    required this.failedAmount,
    required this.completedCount,
    required this.pendingCount,
    required this.failedCount,
  });

  factory AdminTransactionSummary.fromJson(Map<String, dynamic> json) {
    return AdminTransactionSummary(
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0,
      pendingAmount: (json['pendingAmount'] as num?)?.toDouble() ?? 0,
      failedAmount: (json['failedAmount'] as num?)?.toDouble() ?? 0,
      completedCount: (json['completedCount'] as num?)?.toInt() ?? 0,
      pendingCount: (json['pendingCount'] as num?)?.toInt() ?? 0,
      failedCount: (json['failedCount'] as num?)?.toInt() ?? 0,
    );
  }

  static const empty = AdminTransactionSummary(
    totalAmount: 0,
    paidAmount: 0,
    pendingAmount: 0,
    failedAmount: 0,
    completedCount: 0,
    pendingCount: 0,
    failedCount: 0,
  );
}

class AdminTransactionPagination {
  final int page;
  final int limit;
  final int total;
  final int pages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const AdminTransactionPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory AdminTransactionPagination.fromJson(Map<String, dynamic> json) {
    return AdminTransactionPagination(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      total: (json['total'] as num?)?.toInt() ?? 0,
      pages: (json['pages'] as num?)?.toInt() ?? 0,
      hasNextPage: json['hasNextPage'] == true,
      hasPreviousPage: json['hasPreviousPage'] == true,
    );
  }
}

class AdminTransactionsResponse {
  final List<AdminTransactionModel> transactions;
  final AdminTransactionSummary summary;
  final AdminTransactionPagination pagination;
  final String currency;

  const AdminTransactionsResponse({
    required this.transactions,
    required this.summary,
    required this.pagination,
    required this.currency,
  });

  factory AdminTransactionsResponse.fromJson(Map<String, dynamic> json) {
    final transactionsJson = json['transactions'] as List<dynamic>? ?? [];

    return AdminTransactionsResponse(
      transactions: transactionsJson
          .map(
            (item) => AdminTransactionModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      summary: json['summary'] is Map
          ? AdminTransactionSummary.fromJson(
              Map<String, dynamic>.from(json['summary'] as Map),
            )
          : AdminTransactionSummary.empty,
      pagination: json['pagination'] is Map
          ? AdminTransactionPagination.fromJson(
              Map<String, dynamic>.from(json['pagination'] as Map),
            )
          : const AdminTransactionPagination(
              page: 1,
              limit: 20,
              total: 0,
              pages: 0,
              hasNextPage: false,
              hasPreviousPage: false,
            ),
      currency: json['currency']?.toString() ?? '',
    );
  }
}
