import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/status_badge.dart';

class CustomerRowData {
  const CustomerRowData({
    required this.name,
    required this.email,
    required this.joinDate,
    required this.totalOrders,
    required this.totalSpent,
    required this.status,
    required this.statusTone,
    this.avatarUrl,
  });

  final String name;
  final String email;
  final String joinDate;
  final String totalOrders;
  final String totalSpent;
  final String status;
  final StatusTone statusTone;
  final String? avatarUrl;
}

class CustomerRow extends StatelessWidget {
  const CustomerRow({super.key, required this.data});

  final CustomerRowData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: DashboardColors.dividerLight))),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: DashboardColors.accentSoft,
            backgroundImage: data.avatarUrl != null ? NetworkImage(data.avatarUrl!) : null,
            child: data.avatarUrl == null ? const Icon(Icons.person, size: 16, color: Colors.white) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.name, style: const TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 12.5, fontWeight: FontWeight.w600)),
                Text(data.email, style: const TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 11)),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text(data.joinDate, style: const TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 12))),
          Expanded(flex: 1, child: Text(data.totalOrders, style: const TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 12.5))),
          Expanded(flex: 2, child: Text(data.totalSpent, style: const TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 12.5, fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: StatusBadge(label: data.status, tone: data.statusTone)),
        ],
      ),
    );
  }
}
