import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/notification/domain/entity/notification_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,

    required this.notification,

    required this.onTap,
    required this.onTapStar,
  });

  final NotificationEntity notification;

  final VoidCallback onTap;
  final VoidCallback onTapStar;

  @override
  Widget build(BuildContext context) {
    // final formatter = DateFormat.yMMMMd('en_US');
    final formattedDate = DateFormat.MMMd(
      'en_US',
    ).format(notification.createdAt);

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        notification.title,

                        style: !notification.isRead
                            ? AppStyles.textStylesSemiBold18(
                                context,
                              ).copyWith(color: Colors.black)
                            : AppStyles.textStylesRegular16(context).copyWith(
                                color: const Color.fromARGB(132, 0, 0, 0),
                              ),
                      ),
                      const Spacer(),
                      Text(
                        formattedDate,
                        style: !notification.isRead
                            ? AppStyles.textStylesSemiBold14(context).copyWith(
                                color: const Color.fromARGB(176, 0, 0, 0),
                              )
                            : AppStyles.textStylesRegular16(context).copyWith(
                                color: const Color.fromARGB(176, 0, 0, 0),
                              ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        notification.body,
                        style: !notification.isRead
                            ? AppStyles.textStylesSemiBold14(context).copyWith(
                                color: const Color.fromARGB(176, 0, 0, 0),
                              )
                            : AppStyles.textStylesRegular16(context).copyWith(
                                color: const Color.fromARGB(176, 0, 0, 0),
                              ),
                      ),

                      const Spacer(),
                      IconButton(
                        onPressed: onTapStar,
                        icon: notification.isFavourite
                            ? const Icon(Icons.star, color: Colors.red)
                            : const Icon(Icons.star_border_outlined),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
