
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:e_commerce/core/services/get_it_services.dart';

import '../cubit/admin_transactions_cubit.dart';
import '../cubit/admin_transactions_state.dart';
import '../../data/models/admin_transaction_model.dart';

class AdminPayoutsView extends StatelessWidget {
  const AdminPayoutsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminTransactionsCubit>(
      create: (_) => getIt<AdminTransactionsCubit>()..loadTransactions(),
      child: const _AdminTransactionsBody(),
    );
  }
}

class _AdminTransactionsBody extends StatefulWidget {
  const _AdminTransactionsBody();

  @override
  State<_AdminTransactionsBody> createState() =>
      _AdminTransactionsBodyState();
}

class _AdminTransactionsBodyState extends State<_AdminTransactionsBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminTransactionsCubit, AdminTransactionsState>(
      builder: (context, state) {
        if (state is AdminTransactionsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is AdminTransactionsError) {
          return _ErrorView(
            message: state.message,
            onRetry: () {
              context
                  .read<AdminTransactionsCubit>()
                  .loadTransactions();
            },
          );
        }

        if (state is! AdminTransactionsLoaded) {
          return const SizedBox.shrink();
        }

        return RefreshIndicator(
          onRefresh: () {
            return context
                .read<AdminTransactionsCubit>()
                .refresh();
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 700;

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(
                  isMobile ? 16 : 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(
                      context,
                      state,
                      isMobile,
                    ),
                    const SizedBox(height: 24),
                    _buildSummaryCards(
                      state,
                      isMobile,
                    ),
                    const SizedBox(height: 24),
                    _buildFilters(
                      context,
                      state,
                      isMobile,
                    ),
                    const SizedBox(height: 16),
                    _buildTransactionsTable(
                      context,
                      state,
                      isMobile,
                    ),
                    const SizedBox(height: 16),
                    _buildPagination(
                      context,
                      state,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AdminTransactionsLoaded state,
    bool isMobile,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transactions',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                '${state.pagination.total} transactions',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        if (!isMobile)
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              context
                  .read<AdminTransactionsCubit>()
                  .refresh();
            },
            icon: const Icon(Icons.refresh),
          ),
      ],
    );
  }

  Widget _buildSummaryCards(
    AdminTransactionsLoaded state,
    bool isMobile,
  ) {
    final summary = state.summary;

    final cards = [
      _SummaryCardData(
        title: 'Total',
        value: _money(
          summary.totalAmount,
          state.currency,
        ),
        icon: Icons.account_balance_wallet_outlined,
      ),
      _SummaryCardData(
        title: 'Completed',
        value: _money(
          summary.paidAmount,
          state.currency,
        ),
        icon: Icons.check_circle_outline,
      ),
      _SummaryCardData(
        title: 'Pending',
        value: _money(
          summary.pendingAmount,
          state.currency,
        ),
        icon: Icons.schedule_outlined,
      ),
      _SummaryCardData(
        title: 'Failed',
        value: _money(
          summary.failedAmount,
          state.currency,
        ),
        icon: Icons.error_outline,
      ),
    ];

    if (isMobile) {
      return Column(
        children: cards
            .map(
              (card) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: _SummaryCard(
                  data: card,
                ),
              ),
            )
            .toList(),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.9,
      ),
      itemBuilder: (_, index) {
        return _SummaryCard(
          data: cards[index],
        );
      },
    );
  }

  Widget _buildFilters(
    BuildContext context,
    AdminTransactionsLoaded state,
    bool isMobile,
  ) {
    final cubit = context.read<AdminTransactionsCubit>();

    final searchField = TextField(
      controller: _searchController,
      onChanged: (value) {
        cubit.search(value);
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: 'Search transactions...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _searchController.clear();
                  cubit.search('');
                  setState(() {});
                },
                icon: const Icon(Icons.clear),
              ),
        border: const OutlineInputBorder(),
      ),
    );

    final statusDropdown =
        DropdownButtonFormField<String>(
      initialValue: state.status,
      decoration: const InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(
          value: 'all',
          child: Text('All'),
        ),
        DropdownMenuItem(
          value: 'pending',
          child: Text('Pending'),
        ),
        DropdownMenuItem(
          value: 'completed',
          child: Text('Completed'),
        ),
        DropdownMenuItem(
          value: 'failed',
          child: Text('Failed'),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          cubit.changeStatus(value);
        }
      },
    );

    final paymentDropdown =
        DropdownButtonFormField<String>(
      initialValue: state.paymentMethod,
      decoration: const InputDecoration(
        labelText: 'Payment',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(
          value: 'all',
          child: Text('All'),
        ),
        DropdownMenuItem(
          value: 'card',
          child: Text('Card'),
        ),
        DropdownMenuItem(
          value: 'cash',
          child: Text('Cash'),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          cubit.changePaymentMethod(value);
        }
      },
    );

    if (isMobile) {
      return Column(
        children: [
          searchField,
          const SizedBox(height: 12),
          statusDropdown,
          const SizedBox(height: 12),
          paymentDropdown,
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: searchField,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: statusDropdown,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: paymentDropdown,
        ),
      ],
    );
  }

  Widget _buildTransactionsTable(
    BuildContext context,
    AdminTransactionsLoaded state,
    bool isMobile,
  ) {
    if (state.transactions.isEmpty) {
      return const _EmptyView();
    }

    if (isMobile) {
      return Column(
        children: state.transactions
            .map(
              (transaction) => _TransactionCard(
                transaction: transaction,
                currency: state.currency,
                onTap: () {
                  _showTransactionDetails(
                    context,
                    transaction,
                  );
                },
              ),
            )
            .toList(),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(
              label: Text('Transaction'),
            ),
            DataColumn(
              label: Text('Customer'),
            ),
            DataColumn(
              label: Text('Amount'),
            ),
            DataColumn(
              label: Text('Payment'),
            ),
            DataColumn(
              label: Text('Status'),
            ),
            DataColumn(
              label: Text('Date'),
            ),
            DataColumn(
              label: Text('Action'),
            ),
          ],
          rows: state.transactions
              .map(
                (transaction) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                        _shortId(transaction.id),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 180,
                        child: Text(
                          transaction.customer?.name
                                      .isNotEmpty ==
                                  true
                              ? transaction.customer!.name
                              : 'Unknown',
                          overflow:
                              TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        _money(
                          transaction.amount,
                          state.currency,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        _capitalize(
                          transaction.paymentMethod,
                        ),
                      ),
                    ),
                    DataCell(
                      _StatusChip(
                        status:
                            transaction.transactionStatus,
                      ),
                    ),
                    DataCell(
                      Text(
                        _formatDate(
                          transaction.createdAt,
                        ),
                      ),
                    ),
                    DataCell(
                      IconButton(
                        tooltip: 'View',
                        onPressed: () {
                          _showTransactionDetails(
                            context,
                            transaction,
                          );
                        },
                        icon: const Icon(
                          Icons.visibility_outlined,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildPagination(
    BuildContext context,
    AdminTransactionsLoaded state,
  ) {
    final pagination = state.pagination;
    final cubit =
        context.read<AdminTransactionsCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          pagination.total == 0
              ? '0'
              : '${pagination.page} / ${pagination.pages}',
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: pagination.hasPreviousPage
              ? cubit.previousPage
              : null,
          icon: const Icon(
            Icons.chevron_left,
          ),
        ),
        IconButton(
          onPressed: pagination.hasNextPage
              ? cubit.nextPage
              : null,
          icon: const Icon(
            Icons.chevron_right,
          ),
        ),
      ],
    );
  }

  Future<void> _showTransactionDetails(
    BuildContext context,
    AdminTransactionModel transaction,
  ) async {
    final cubit =
        context.read<AdminTransactionsCubit>();

    final details =
        await cubit.getTransaction(transaction.id);

    if (!context.mounted) {
      return;
    }

    if (details == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not load transaction details',
          ),
        ),
      );
      return;
    }

    /*
     * IMPORTANT:
     *
     * Do NOT do:
     *
     * context.read<AdminTransactionsState>()
     *
     * AdminTransactionsState is not a provider.
     *
     * The provider is AdminTransactionsCubit.
     *
     * Get the current state from the cubit itself.
     */
    final currentState = cubit.state;

    final currency =
        currentState is AdminTransactionsLoaded
            ? currentState.currency
            : '';

    if (!context.mounted) {
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Transaction details',
          ),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _DetailRow(
                    label: 'Transaction ID',
                    value: details.id,
                  ),
                  _DetailRow(
                    label: 'Order ID',
                    value: details.orderId,
                  ),
                  _DetailRow(
                    label: 'Customer',
                    value: details.customer?.name
                                .isNotEmpty ==
                            true
                        ? details.customer!.name
                        : 'Unknown',
                  ),
                  _DetailRow(
                    label: 'Email',
                    value:
                        details.customer?.email ?? '',
                  ),
                  _DetailRow(
                    label: 'Amount',
                    value: _money(
                      details.amount,
                      currency,
                    ),
                  ),
                  _DetailRow(
                    label: 'Payment',
                    value: _capitalize(
                      details.paymentMethod,
                    ),
                  ),
                  _DetailRow(
                    label: 'Status',
                    value: _capitalize(
                      details.transactionStatus,
                    ),
                  ),
                  _DetailRow(
                    label: 'Order status',
                    value: _capitalize(
                      details.orderStatus,
                    ),
                  ),
                  _DetailRow(
                    label: 'Created',
                    value: _formatDate(
                      details.createdAt,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _money(
    double value,
    String currency,
  ) {
    final formatted =
        value.toStringAsFixed(2);

    if (currency.trim().isEmpty) {
      return formatted;
    }

    return '$formatted ${currency.toUpperCase()}';
  }

  String _shortId(String value) {
    if (value.length <= 10) {
      return value;
    }

    return '${value.substring(0, 6)}...'
        '${value.substring(value.length - 4)}';
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return '';
    }

    return value[0].toUpperCase() +
        value.substring(1);
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '—';
    }

    final local = date.toLocal();

    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/'
        '${local.year}';
  }
}

class _SummaryCardData {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCardData({
    required this.title,
    required this.value,
    required this.icon,
  });
}

class _SummaryCard extends StatelessWidget {
  final _SummaryCardData data;

  const _SummaryCard({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(
              data.icon,
              size: 30,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.value,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          fontWeight:
                              FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final AdminTransactionModel transaction;
  final String currency;
  final VoidCallback onTap;

  const _TransactionCard({
    required this.transaction,
    required this.currency,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      transaction.customer?.name ??
                          'Unknown',
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                  _StatusChip(
                    status:
                        transaction.transactionStatus,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _MobileDetailRow(
                label: 'Transaction',
                value: _shortId(
                  transaction.id,
                ),
              ),
              _MobileDetailRow(
                label: 'Amount',
                value: _money(
                  transaction.amount,
                  currency,
                ),
              ),
              _MobileDetailRow(
                label: 'Payment',
                value: _capitalize(
                  transaction.paymentMethod,
                ),
              ),
              _MobileDetailRow(
                label: 'Date',
                value: _formatDate(
                  transaction.createdAt,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment:
                    Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onTap,
                  icon: const Icon(
                    Icons.visibility_outlined,
                  ),
                  label: const Text(
                    'View details',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _money(
    double value,
    String currency,
  ) {
    final formatted =
        value.toStringAsFixed(2);

    if (currency.trim().isEmpty) {
      return formatted;
    }

    return '$formatted ${currency.toUpperCase()}';
  }

  String _shortId(String value) {
    if (value.length <= 10) {
      return value;
    }

    return '${value.substring(0, 6)}...'
        '${value.substring(value.length - 4)}';
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return '';
    }

    return value[0].toUpperCase() +
        value.substring(1);
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '—';
    }

    final local = date.toLocal();

    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/'
        '${local.year}';
  }
}

class _MobileDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _MobileDetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 6,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                    fontWeight:
                        FontWeight.w600,
                  ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    fontWeight:
                        FontWeight.w600,
                  ),
            ),
          ),
          Expanded(
            child: SelectableText(value),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final normalized =
        status.toLowerCase();

    IconData icon;

    switch (normalized) {
      case 'completed':
      case 'paid':
      case 'success':
        icon = Icons.check_circle_outline;
        break;

      case 'pending':
        icon = Icons.schedule_outlined;
        break;

      case 'failed':
      case 'cancelled':
      case 'canceled':
        icon = Icons.error_outline;
        break;

      default:
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(20),
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
          ),
          const SizedBox(width: 5),
          Text(
            _capitalize(status),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return '';
    }

    return value[0].toUpperCase() +
        value.substring(1);
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 60,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color:
              Theme.of(context).dividerColor,
        ),
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(
                  fontWeight:
                      FontWeight.w600,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'There are no transactions matching your filters.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    fontWeight:
                        FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh,
              ),
              label: const Text(
                'Retry',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
