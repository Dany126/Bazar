import 'package:e_commerce/features/order/domin/entity/order_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_orders_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_orders_state.dart';

class AdminOrdersView extends StatelessWidget {
  const AdminOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminOrdersCubit>(
      create: (_) => getIt<AdminOrdersCubit>()..loadOrders(),
      child: const _AdminOrdersBody(),
    );
  }
}

// ============================================================
// BODY
// ============================================================

class _AdminOrdersBody extends StatefulWidget {
  const _AdminOrdersBody();

  @override
  State<_AdminOrdersBody> createState() => _AdminOrdersBodyState();
}

class _AdminOrdersBodyState extends State<_AdminOrdersBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminOrdersCubit, AdminOrdersState>(
      listener: (context, state) {
        if (state is AdminOrdersError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),

            const SizedBox(height: 24),

            _buildSearch(),

            const SizedBox(height: 24),

            const Expanded(child: _OrdersContent()),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Orders',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Text(
          'Manage customer orders and update their status.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearch() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        context.read<AdminOrdersCubit>().searchOrders(value);

        setState(() {});
      },
      decoration: InputDecoration(
        hintText: 'Search orders...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();

                  context.read<AdminOrdersCubit>().clearSearch();

                  setState(() {});
                },
              ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ============================================================
// ORDERS CONTENT
// ============================================================

class _OrdersContent extends StatelessWidget {
  const _OrdersContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminOrdersCubit, AdminOrdersState>(
      builder: (context, state) {
        // ======================================================
        // INITIAL
        // ======================================================

        if (state is AdminOrdersInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        // ======================================================
        // FIRST LOAD
        // ======================================================

        if (state is AdminOrdersLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // ======================================================
        // PAGE LOADING
        // ======================================================

        if (state is AdminOrdersLoadingPage) {
          return Column(
            children: [
              Expanded(
                child: _buildOrdersList(
                  context,
                  state.previousPage.orders,
                  searchQuery: state.searchQuery,
                  updatingOrderId: state.updatingOrderId,
                  deletingOrderId: state.deletingOrderId,
                ),
              ),

              const SizedBox(height: 16),

              const SizedBox(
                height: 50,
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        }

        // ======================================================
        // ERROR
        // ======================================================

        if (state is AdminOrdersError) {
          return _ErrorView(message: state.message);
        }

        // ======================================================
        // LOADED
        // ======================================================

        if (state is AdminOrdersLoaded) {
          final orders = state.filteredOrders;

          if (orders.isEmpty) {
            return const _EmptyView();
          }

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: context.read<AdminOrdersCubit>().refreshOrders,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      return _OrderCard(
                        order: order,
                        isUpdating: state.updatingOrderId == order.id,
                        isDeleting: state.deletingOrderId == order.id,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _OrdersPagination(
                currentPage: state.currentPage,
                totalPages: state.totalPages,
                totalItems: state.totalItems,
                itemsPerPage: state.itemsPerPage,

                hasPreviousPage: state.hasPreviousPage,
                hasNextPage: state.hasNextPage,
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildOrdersList(
    BuildContext context,
    List<OrderEntity> orders, {
    required String searchQuery,
    required String? updatingOrderId,
    required String? deletingOrderId,
  }) {
    final query = searchQuery.trim().toLowerCase();

    final filtered = query.isEmpty
        ? orders
        : orders.where((order) {
            return order.id.toLowerCase().contains(query) ||
                order.orderStatus.toLowerCase().contains(query) ||
                order.paymentStatus.toLowerCase().contains(query) ||
                order.paymentMethod.toLowerCase().contains(query);
          }).toList();

    if (filtered.isEmpty) {
      return const _EmptyView();
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = filtered[index];

        return _OrderCard(
          order: order,
          isUpdating: updatingOrderId == order.id,
          isDeleting: deletingOrderId == order.id,
        );
      },
    );
  }
}

// ============================================================
// ORDER CARD
// ============================================================

class _OrderCard extends StatelessWidget {
  final OrderEntity order;

  final bool isUpdating;
  final bool isDeleting;

  const _OrderCard({
    required this.order,
    required this.isUpdating,
    required this.isDeleting,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmall = constraints.maxWidth < 700;

            if (isSmall) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _OrderInformation(order: order),
                  const SizedBox(height: 16),
                  _OrderActions(
                    order: order,
                    isUpdating: isUpdating,
                    isDeleting: isDeleting,
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: _OrderInformation(order: order)),

                const SizedBox(width: 24),

                _OrderActions(
                  order: order,
                  isUpdating: isUpdating,
                  isDeleting: isDeleting,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// ORDER INFORMATION
// ============================================================

class _OrderInformation extends StatelessWidget {
  final OrderEntity order;

  const _OrderInformation({required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order #${order.id}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 20,
          runSpacing: 12,
          children: [
            _InfoItem(
              label: 'Total',
              value: '\$${order.totalPrice.toStringAsFixed(2)}',
            ),

            _InfoItem(
              label: 'Payment',
              value: _formatStatus(order.paymentStatus),
            ),

            _InfoItem(
              label: 'Method',
              value: _formatStatus(order.paymentMethod),
            ),

            _InfoItem(label: 'Status', value: _formatStatus(order.orderStatus)),
          ],
        ),
      ],
    );
  }

  String _formatStatus(String value) {
    return value
        .split('_')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}'
                    '${word.substring(1)}',
        )
        .join(' ');
  }
}

// ============================================================
// INFO ITEM
// ============================================================

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ============================================================
// ACTIONS
// ============================================================

class _OrderActions extends StatelessWidget {
  final OrderEntity order;

  final bool isUpdating;
  final bool isDeleting;

  const _OrderActions({
    required this.order,
    required this.isUpdating,
    required this.isDeleting,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isUpdating)
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else
          _StatusDropdown(order: order),

        const SizedBox(width: 8),

        if (isDeleting)
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else
          IconButton(
            tooltip: 'Delete order',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context),
          ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete order?'),
          content: Text(
            'Are you sure you want to delete '
            'order #${order.id}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    await context.read<AdminOrdersCubit>().deleteOrder(order.id);
  }
}

// ============================================================
// STATUS DROPDOWN
// ============================================================

class _StatusDropdown extends StatelessWidget {
  final OrderEntity order;

  const _StatusDropdown({required this.order});

  @override
  Widget build(BuildContext context) {
    const statuses = [
      'pending',
      'confirmed',
      'processing',
      'shipped',
      'delivered',
      'cancelled',
    ];

    final currentStatus = statuses.contains(order.orderStatus)
        ? order.orderStatus
        : null;

    return DropdownButton<String>(
      value: currentStatus,
      hint: Text(_formatStatus(order.orderStatus)),
      underline: const SizedBox.shrink(),
      items: statuses.map((status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(_formatStatus(status)),
        );
      }).toList(),
      onChanged: (value) async {
        if (value == null || value == order.orderStatus) {
          return;
        }

        await context.read<AdminOrdersCubit>().updateOrderStatus(
          orderId: order.id,
          orderStatus: value,
        );
      },
    );
  }

  String _formatStatus(String value) {
    return value
        .split('_')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}'
                    '${word.substring(1)}',
        )
        .join(' ');
  }
}

// ============================================================
// EMPTY
// ============================================================

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No orders found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text(
            'There are no orders matching your search.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ERROR
// ============================================================

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 60),

          const SizedBox(height: 16),

          Text(message, textAlign: TextAlign.center),

          const SizedBox(height: 16),

          FilledButton(
            onPressed: () {
              context.read<AdminOrdersCubit>().loadOrders();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PAGINATION
// ============================================================

class _OrdersPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  final bool hasPreviousPage;
  final bool hasNextPage;

  const _OrdersPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminOrdersCubit>();

    final state = context.watch<AdminOrdersCubit>().state;

    final bool isLoading = state is AdminOrdersLoadingPage;

    final int startItem = totalItems == 0
        ? 0
        : ((currentPage - 1) * itemsPerPage) + 1;

    final int endItem = totalItems == 0
        ? 0
        : ((currentPage * itemsPerPage) > totalItems
              ? totalItems
              : currentPage * itemsPerPage);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isSmall = constraints.maxWidth < 600;

          if (isSmall) {
            return Column(
              children: [
                Text(
                  totalItems == 0
                      ? 'No orders'
                      : 'Showing $startItem-$endItem of $totalItems orders',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 12),
                _buildControls(context, cubit, isLoading),
              ],
            );
          }

          return Row(
            children: [
              Text(
                totalItems == 0
                    ? 'No orders'
                    : 'Showing $startItem-$endItem of $totalItems orders',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),

              const Spacer(),

              _buildControls(context, cubit, isLoading),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControls(
    BuildContext context,
    AdminOrdersCubit cubit,
    bool isLoading,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // FIRST PAGE
        IconButton(
          tooltip: 'First page',
          onPressed: !isLoading && hasPreviousPage ? cubit.firstPage : null,
          icon: const Icon(Icons.first_page),
        ),

        // PREVIOUS PAGE
        IconButton(
          tooltip: 'Previous page',
          onPressed: !isLoading && hasPreviousPage ? cubit.previousPage : null,
          icon: const Icon(Icons.chevron_left),
        ),

        const SizedBox(width: 8),

        // PAGE NUMBER
        Container(
          constraints: const BoxConstraints(minWidth: 42, minHeight: 38),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$currentPage / $totalPages',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(width: 8),

        // NEXT PAGE
        IconButton(
          tooltip: 'Next page',
          onPressed: !isLoading && hasNextPage ? cubit.nextPage : null,
          icon: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.chevron_right),
        ),

        // LAST PAGE
        IconButton(
          tooltip: 'Last page',
          onPressed: !isLoading && currentPage < totalPages
              ? cubit.lastPage
              : null,
          icon: const Icon(Icons.last_page),
        ),
      ],
    );
  }
}
