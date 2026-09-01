import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AdminWorkspaceView extends StatelessWidget {
  const AdminWorkspaceView({super.key});

  @override
  Widget build(BuildContext context) {
    final members = [
      {'name': 'Ahmed Hassan', 'role': 'Admin', 'icon': Icons.admin_panel_settings},
      {'name': 'Sara Ali', 'role': 'Editor', 'icon': Icons.edit},
      {'name': 'Omar Khalid', 'role': 'Viewer', 'icon': Icons.visibility},
      {'name': 'Fatima Noor', 'role': 'Viewer', 'icon': Icons.visibility},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workspace',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Team Members', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: members.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final m = members[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                          child: Icon(m['icon'] as IconData, color: AppColors.kPrimaryColor, size: 20),
                        ),
                        title: Text(m['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(m['role'] as String),
                        trailing: IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
                      );
                    },
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
