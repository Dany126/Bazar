import 'package:flutter/material.dart';

class AdminPayoutsView extends StatelessWidget {
  const AdminPayoutsView({super.key});

  @override
  Widget build(BuildContext context) {
    final payouts = [
      {'id': '#1042', 'date': '2026-08-25', 'amount': 2250.00},
      {'id': '#1041', 'date': '2026-08-18', 'amount': 1800.00},
      {'id': '#1040', 'date': '2026-08-11', 'amount': 1350.00},
      {'id': '#1039', 'date': '2026-08-04', 'amount': 900.00},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payouts',
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
              itemCount: payouts.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final p = payouts[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEAFBF4),
                    child: Icon(Icons.check, color: Color(0xFF1DAF73)),
                  ),
                  title: Text('Payout ${p['id']}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Processed on ${p['date']}'),
                  trailing: Text(
                    '+\$${(p['amount'] as double).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1DAF73)),
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
