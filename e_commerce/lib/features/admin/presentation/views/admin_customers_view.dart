import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AdminCustomersView extends StatelessWidget {
  const AdminCustomersView({super.key});

  @override
  Widget build(BuildContext context) {
    final customers = [
      {'name': 'Sarah Johnson', 'email': 'sarah.j@email.com', 'spent': 1240.00, 'orders': 12},
      {'name': 'Michael Chen', 'email': 'michael.c@email.com', 'spent': 890.50, 'orders': 8},
      {'name': 'Emma Williams', 'email': 'emma.w@email.com', 'spent': 2150.00, 'orders': 23},
      {'name': 'James Brown', 'email': 'james.b@email.com', 'spent': 560.75, 'orders': 5},
      {'name': 'Olivia Davis', 'email': 'olivia.d@email.com', 'spent': 3420.00, 'orders': 31},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customers',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: customers.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final c = customers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                    child: Text(
                      (c['name'] as String).substring(0, 1),
                      style: const TextStyle(color: AppColors.kPrimaryColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                  title: Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(c['email'] as String),
                  trailing: Text(
                    '\$${(c['spent'] as double).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
