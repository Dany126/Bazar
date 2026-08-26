import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/section_card.dart';

class CustomerInfoCard extends StatelessWidget {
  const CustomerInfoCard({super.key, required this.name, required this.email, required this.phone, this.avatarUrl});

  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      background: DashboardColors.cardBgDarkAlt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Customer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13.5)),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: DashboardColors.accentSoft,
                backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                child: avatarUrl == null ? const Icon(Icons.person, size: 18, color: Colors.white) : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600)),
                    Text('Customer since Jan 2026', style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 10.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(children: [const Icon(Icons.email_outlined, size: 14, color: DashboardColors.textSecondaryDark), const SizedBox(width: 8), Text(email, style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11.5))]),
          const SizedBox(height: 6),
          Row(children: [const Icon(Icons.call_outlined, size: 14, color: DashboardColors.textSecondaryDark), const SizedBox(width: 8), Text(phone, style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11.5))]),
        ],
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  const AddressCard({super.key, required this.title, required this.lines, this.editable = false});

  final String title;
  final List<String> lines;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      background: DashboardColors.cardBgDarkAlt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13.5)),
              if (editable) const Text('Edit', style: TextStyle(color: DashboardColors.accent, fontSize: 11.5, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          for (final l in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(l, style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12)),
            ),
        ],
      ),
    );
  }
}
