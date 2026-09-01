import 'package:flutter/material.dart';

class AdminOverviewView extends StatelessWidget {
  const AdminOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 24),
          const Text('Detailed analytics and overviews will appear here.'),
        ],
      ),
    );
  }
}
