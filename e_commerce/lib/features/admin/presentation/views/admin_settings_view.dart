import 'package:flutter/material.dart';

class AdminSettingsView extends StatelessWidget {
  const AdminSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Store Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: 'Marketplace Store',
                    decoration: const InputDecoration(labelText: 'Store Name', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: 'admin@marketplace.com',
                    decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 24),
                  const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  SwitchListTile(
                    title: const Text('Email Notifications'),
                    value: true,
                    onChanged: (val) {},
                  ),
                  SwitchListTile(
                    title: const Text('Order Alerts'),
                    value: true,
                    onChanged: (val) {},
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
