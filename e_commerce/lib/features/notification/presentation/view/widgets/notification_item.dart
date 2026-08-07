import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/notification/domain/entity/notification_entity.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,

    required this.notification,

    required this.onTap,
  });

  final NotificationEntity notification;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,

        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.white
              : AppColors.kSecondaryAccentColor,

          borderRadius: BorderRadius.circular(10),

          border: Border.all(color: Colors.grey.shade300),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Padding(
              padding: const EdgeInsets.all(8),

              child: Image.asset(
                notification.isRead
                    ? Assets.assetsImagesInActivenotificationbing
                    : Assets.assetsImagesUnSeennotificationbing,

                width: 24,

                height: 24,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    notification.title,

                    style: const TextStyle(
                      fontSize: 16,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(notification.body, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
