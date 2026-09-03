import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AdminDashboardStatCard extends StatelessWidget {
  const AdminDashboardStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.change,
    required this.color,
    this.comparisonLabel = 'vs previous period',
    this.isPrimary = false,
  });

  final String label;
  final String value;
  final String change;
  final Color color;
  final bool isPrimary;
  final String comparisonLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFF1E1B3A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative background circle for non-primary
          if (!isPrimary)
            Positioned(
              right: -20,
              bottom: -10,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.07),
                ),
              ),
            ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      label.toUpperCase(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isPrimary
                            ? Colors.white70
                            : AppColors.kSecondaryTextColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isPrimary
                          ? Colors.white.withValues(alpha: 0.1)
                          : color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _changeIcon(),
                      color: isPrimary ? Colors.white : color,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: isPrimary ? Colors.white : AppColors.kTextColor,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(
                    change == 'No data'
                        ? Icons.remove_rounded
                        : Icons.trending_up_rounded,
                    color: change == 'No data'
                        ? (isPrimary
                              ? Colors.white54
                              : AppColors.kSecondaryTextColor)
                        : (isPrimary
                              ? Colors.greenAccent
                              : const Color(0xFF1DAF73)),
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    change,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: change == 'No data'
                          ? (isPrimary
                                ? Colors.white54
                                : AppColors.kSecondaryTextColor)
                          : (isPrimary
                                ? Colors.greenAccent
                                : const Color(0xFF1DAF73)),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    comparisonLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isPrimary
                          ? Colors.white54
                          : AppColors.kSecondaryTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _changeIcon() {
    if (change == 'No data') {
      return Icons.remove_rounded;
    }

    final numericChange = double.tryParse(
      change.replaceAll('%', '').replaceAll('+', ''),
    );

    if (numericChange == null) {
      return Icons.remove_rounded;
    }

    if (numericChange > 0) {
      return Icons.trending_up_rounded;
    }

    if (numericChange < 0) {
      return Icons.trending_down_rounded;
    }

    return Icons.remove_rounded;
  }
}
