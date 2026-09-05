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
    final width = MediaQuery.sizeOf(context).width;

    final isPhone = width < 600;
    final isTablet = width >= 600 && width < 1000;

    final horizontalMargin = isPhone
        ? 12.0
        : isTablet
        ? 20.0
        : 24.0;

    final padding = isPhone
        ? 12.0
        : isTablet
        ? 14.0
        : 16.0;

    final iconSize = isPhone ? 22.0 : 24.0;

    final titleStyle = !notification.isRead
        ? AppStyles.textStylesSemiBold18(context).copyWith(color: Colors.black)
        : AppStyles.textStylesRegular16(
            context,
          ).copyWith(color: const Color.fromARGB(132, 0, 0, 0));

    final bodyStyle = !notification.isRead
        ? AppStyles.textStylesSemiBold14(
            context,
          ).copyWith(color: const Color.fromARGB(176, 0, 0, 0))
        : AppStyles.textStylesRegular16(
            context,
          ).copyWith(color: const Color.fromARGB(176, 0, 0, 0));

    final dateStyle = !notification.isRead
        ? AppStyles.textStylesSemiBold14(
            context,
          ).copyWith(color: const Color.fromARGB(176, 0, 0, 0))
        : AppStyles.textStylesRegular16(
            context,
          ).copyWith(color: const Color.fromARGB(176, 0, 0, 0));

    final formattedDate = DateFormat.MMMd(
      'en_US',
    ).format(notification.createdAt);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 6),
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.white
              : AppColors.kSecondaryAccentColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 4, right: isPhone ? 8 : 10),
              child: Image.asset(
                notification.isRead
                    ? Assets.assetsImagesInActivenotificationbing
                    : Assets.assetsImagesUnSeennotificationbing,
                width: iconSize,
                height: iconSize,
              ),
            ),

            SizedBox(width: isPhone ? 8 : 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE + DATE
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxWidth < 350;

                      if (compact) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: titleStyle,
                            ),
                            const SizedBox(height: 3),
                            Text(formattedDate, style: dateStyle),
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: titleStyle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              formattedDate,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: dateStyle,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 5),

                  // BODY + STAR
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.body,
                          maxLines: isPhone ? 3 : 4,
                          overflow: TextOverflow.ellipsis,
                          style: bodyStyle,
                        ),
                      ),

                      const SizedBox(width: 4),

                      SizedBox(
                        width: isPhone ? 36 : 40,
                        height: isPhone ? 36 : 40,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: onTapStar,
                          icon: notification.isFavourite
                              ? Icon(
                                  Icons.star,
                                  color: Colors.red,
                                  size: isPhone ? 21 : 23,
                                )
                              : Icon(
                                  Icons.star_border_outlined,
                                  size: isPhone ? 21 : 23,
                                ),
                        ),
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
