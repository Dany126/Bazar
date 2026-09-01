import 'package:flutter/material.dart';

class AdminEarningsView extends StatelessWidget {
  const AdminEarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Earnings',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 600;
              final cards = [
                _buildEarningsCard(
                  'Available Balance',
                  '\$12,450.00',
                  isDark: true,
                ),
                _buildEarningsCard(
                  'Total Earnings',
                  '\$142,500.00',
                  isDark: false,
                ),
              ];

              if (isWide) {
                return Row(
                  children: [
                    Expanded(child: cards[0]),
                    const SizedBox(width: 16),
                    Expanded(child: cards[1]),
                  ],
                );
              }
              return Column(
                children: [
                  cards[0],
                  const SizedBox(height: 16),
                  cards[1],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsCard(String title, String value, {required bool isDark}) {
    return Card(
      elevation: 0,
      color: isDark ? const Color(0xFF1E1B3A) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: isDark ? Colors.white70 : Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
