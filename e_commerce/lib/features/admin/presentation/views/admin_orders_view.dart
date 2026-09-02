import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/order/domin/entity/order_entity.dart';
import 'package:e_commerce/features/order/presenation/modelview/cubit/order_cubit.dart';
import 'package:e_commerce/features/order/presenation/modelview/cubit/order_state.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/order_detail_view.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/order_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AdminOrdersView extends StatelessWidget {
  const AdminOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrderCubit>()..getMyOrders(filter: OrderStatus.all),
      child: const _AdminOrdersBody(),
    );
  }
}

class _AdminOrdersBody extends StatelessWidget {
  const _AdminOrdersBody();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return context.read<OrderCubit>().getMyOrders(filter: OrderStatus.all);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Orders',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'All customer orders',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            BlocBuilder<OrderCubit, OrderState>(
              builder: (context, state) {
                if (state is OrderLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 80),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is OrderError) {
                  return _ErrorState(
                    message: state.message,
                    onRetry: () {
                      context.read<OrderCubit>().getMyOrders(
                        filter: OrderStatus.all,
                      );
                    },
                  );
                }

                if (state is OrdersLoaded) {
                  if (state.orders.isEmpty) {
                    return const _EmptyOrders();
                  }

                  return _OrdersTable(orders: state.orders);
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OrdersTable extends StatelessWidget {
  final List<OrderEntity> orders;

  const _OrdersTable({required this.orders});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 32,
          headingRowHeight: 56,
          dataRowMinHeight: 64,
          dataRowMaxHeight: 72,
          columns: const [
            DataColumn(label: Text('Order')),
            DataColumn(label: Text('Customer')),
            DataColumn(label: Text('Total')),
            DataColumn(label: Text('Payment')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('')),
          ],
          rows: orders.map((order) {
            return DataRow(
              cells: [
                DataCell(
                  SizedBox(
                    width: 120,
                    child: Text(
                      _shortId(order.id),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 130,
                    child: Text(
                      _shortId(order.user),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text('${order.totalPrice.toStringAsFixed(2)} EGP')),
                DataCell(_StatusChip(text: order.paymentStatus)),
                DataCell(_StatusChip(text: order.orderStatus)),
                DataCell(
                  Text(
                    order.createdAt == null
                        ? '-'
                        : DateFormat('dd MMM yyyy').format(order.createdAt!),
                  ),
                ),
                DataCell(
                  IconButton(
                    tooltip: 'View order',
                    icon: const Icon(Icons.visibility_outlined),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => OrderDetailView(order: order),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  String _shortId(String value) {
    if (value.length <= 10) {
      return value;
    }

    return '${value.substring(0, 6)}...';
  }
}

class _StatusChip extends StatelessWidget {
  final String text;

  const _StatusChip({required this.text});

  @override
  Widget build(BuildContext context) {
    final value = text.trim().isEmpty ? '-' : text;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        value.toUpperCase(),
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.receipt_long_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No orders yet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 56, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}
