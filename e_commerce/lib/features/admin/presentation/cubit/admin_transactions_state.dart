import '../../data/model/admin_transaction_model.dart';

abstract class AdminTransactionsState {
  const AdminTransactionsState();
}

class AdminTransactionsInitial extends AdminTransactionsState {
  const AdminTransactionsInitial();
}

class AdminTransactionsLoading extends AdminTransactionsState {
  const AdminTransactionsLoading();
}

class AdminTransactionsLoaded extends AdminTransactionsState {
  final List<AdminTransactionModel> transactions;
  final AdminTransactionSummary summary;
  final AdminTransactionPagination pagination;
  final String currency;

  final String searchQuery;
  final String status;
  final String paymentMethod;

  const AdminTransactionsLoaded({
    required this.transactions,
    required this.summary,
    required this.pagination,
    required this.currency,
    required this.searchQuery,
    required this.status,
    required this.paymentMethod,
  });

  AdminTransactionsLoaded copyWith({
    List<AdminTransactionModel>? transactions,
    AdminTransactionSummary? summary,
    AdminTransactionPagination? pagination,
    String? currency,
    String? searchQuery,
    String? status,
    String? paymentMethod,
  }) {
    return AdminTransactionsLoaded(
      transactions: transactions ?? this.transactions,
      summary: summary ?? this.summary,
      pagination: pagination ?? this.pagination,
      currency: currency ?? this.currency,
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}

class AdminTransactionsError extends AdminTransactionsState {
  final String message;

  const AdminTransactionsError({required this.message});
}
