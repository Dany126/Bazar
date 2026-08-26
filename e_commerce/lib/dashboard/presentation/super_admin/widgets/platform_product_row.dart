import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/status_badge.dart';

class PlatformProductRowData {
  const PlatformProductRowData({
    required this.name,
    required this.seller,
    required this.price,
    required this.status,
    required this.statusTone,
    this.flagged = false,
    this.imageUrl,
  });

  final String name;
  final String seller;
  final String price;
  final String status;
  final StatusTone statusTone;
  final bool flagged;
  final String? imageUrl;
}

class PlatformProductRow extends StatelessWidget {
  const PlatformProductRow({super.key, required this.data});

  final PlatformProductRowData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: data.flagged ? DashboardColors.danger.withOpacity(0.08) : Colors.transparent,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: DashboardColors.contentBgLight,
              borderRadius: BorderRadius.circular(8),
              image: data.imageUrl != null
                  ? DecorationImage(image: NetworkImage(data.imageUrl!), fit: BoxFit.cover)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(data.name,
                style: const TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 12.5, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 2,
            child: Text(data.seller, style: const TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 12)),
          ),
          Expanded(
            flex: 1,
            child: Text(data.price,
                style: const TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 12.5, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 2,
            child: StatusBadge(label: data.status, tone: data.statusTone),
          ),
          SizedBox(
            width: 90,
            child: data.flagged
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                        child: const Text('Restore', style: TextStyle(color: Colors.white, fontSize: 11)),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.delete_outline_rounded, color: DashboardColors.danger, size: 18),
                    ],
                  )
                : const Icon(Icons.more_horiz, color: DashboardColors.textSecondaryLight, size: 18),
          ),
        ],
      ),
    );
  }
}
