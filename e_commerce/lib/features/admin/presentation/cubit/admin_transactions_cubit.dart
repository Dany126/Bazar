import 'dart:async';

import 'package:e_commerce/features/admin/data/models/admin_transaction_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_admin_transaction.dart';
import '../../domain/usecases/get_admin_transactions.dart';

import 'admin_transactions_state.dart';

class AdminTransactionsCubit extends Cubit<AdminTransactionsState> {
  final GetAdminTransactions getAdminTransactions;
  final GetAdminTransaction getAdminTransaction;

  Timer? _searchDebounce;

  AdminTransactionsCubit({
    required this.getAdminTransactions,
    required this.getAdminTransaction,
  }) : super(const AdminTransactionsInitial());

  Future<void> loadTransactions({
    String search = '',
    String status = 'all',
    String paymentMethod = 'all',
    int page = 1,
  }) async {
    emit(const AdminTransactionsLoading());

    final result = await getAdminTransactions(
      search: search,
      status: status,
      paymentMethod: paymentMethod,
      page: page,
    );

    result.fold(
      (failure) {
        emit(AdminTransactionsError(message: failure.message));
      },
      (data) {
        emit(
          AdminTransactionsLoaded(
            transactions: data.transactions,
            summary: data.summary,
            pagination: data.pagination,
            currency: data.currency,
            searchQuery: search,
            status: status,
            paymentMethod: paymentMethod,
          ),
        );
      },
    );
  }

  void search(String value) {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      final current = state;

      String status = 'all';
      String paymentMethod = 'all';

      if (current is AdminTransactionsLoaded) {
        status = current.status;
        paymentMethod = current.paymentMethod;
      }

      loadTransactions(
        search: value,
        status: status,
        paymentMethod: paymentMethod,
      );
    });
  }

  Future<void> changeStatus(String value) async {
    final current = state;

    String search = '';

    if (current is AdminTransactionsLoaded) {
      search = current.searchQuery;
    }

    await loadTransactions(
      search: search,
      status: value,
      paymentMethod: current is AdminTransactionsLoaded
          ? current.paymentMethod
          : 'all',
    );
  }

  Future<void> changePaymentMethod(String value) async {
    final current = state;

    String search = '';
    String status = 'all';

    if (current is AdminTransactionsLoaded) {
      search = current.searchQuery;
      status = current.status;
    }

    await loadTransactions(
      search: search,
      status: status,
      paymentMethod: value,
    );
  }

  Future<void> nextPage() async {
    final current = state;

    if (current is! AdminTransactionsLoaded) {
      return;
    }

    if (!current.pagination.hasNextPage) {
      return;
    }

    final result = await getAdminTransactions(
      search: current.searchQuery,
      status: current.status,
      paymentMethod: current.paymentMethod,
      page: current.pagination.page + 1,
    );

    result.fold(
      (failure) {
        emit(AdminTransactionsError(message: failure.message));
      },
      (data) {
        emit(
          AdminTransactionsLoaded(
            transactions: data.transactions,
            summary: data.summary,
            pagination: data.pagination,
            currency: data.currency,
            searchQuery: current.searchQuery,
            status: current.status,
            paymentMethod: current.paymentMethod,
          ),
        );
      },
    );
  }

  Future<void> previousPage() async {
    final current = state;

    if (current is! AdminTransactionsLoaded) {
      return;
    }

    if (!current.pagination.hasPreviousPage) {
      return;
    }

    final result = await getAdminTransactions(
      search: current.searchQuery,
      status: current.status,
      paymentMethod: current.paymentMethod,
      page: current.pagination.page - 1,
    );

    result.fold(
      (failure) {
        emit(AdminTransactionsError(message: failure.message));
      },
      (data) {
        emit(
          AdminTransactionsLoaded(
            transactions: data.transactions,
            summary: data.summary,
            pagination: data.pagination,
            currency: data.currency,
            searchQuery: current.searchQuery,
            status: current.status,
            paymentMethod: current.paymentMethod,
          ),
        );
      },
    );
  }

  Future<void> refresh() async {
    final current = state;

    if (current is AdminTransactionsLoaded) {
      await loadTransactions(
        search: current.searchQuery,
        status: current.status,
        paymentMethod: current.paymentMethod,
        page: current.pagination.page,
      );
      return;
    }

    await loadTransactions();
  }

  Future<AdminTransactionModel?> getTransaction(String transactionId) async {
    final result = await getAdminTransaction(transactionId: transactionId);

    return result.fold((_) => null, (transaction) => transaction);
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
