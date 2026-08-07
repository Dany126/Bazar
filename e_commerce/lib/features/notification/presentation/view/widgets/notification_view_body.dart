import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/notification/domain/entity/notification_entity.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'notification_item.dart';

class NotificationViewBody extends StatefulWidget {
  const NotificationViewBody({super.key});

  @override
  State<NotificationViewBody> createState() => _NotificationViewBodyState();
}

class _NotificationViewBodyState extends State<NotificationViewBody> {
  final List<NotificationEntity> notifications = [
    NotificationEntity(
      id: "1",

      title: "Order Placed",

      body: "Your order has been placed successfully",
    ),

    NotificationEntity(
      id: "2",

      title: "Order Shipped",

      body: "Your order is on the way",
    ),

    NotificationEntity(
      id: "3",

      title: "Order Delivered",

      body: "Your order has been delivered",
    ),
  ];

  bool isDeleting = false;

  bool showDeleteAnimation = false;

  void deleteNotification(int index) {
    setState(() {
      isDeleting = true;

      showDeleteAnimation = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          notifications.removeAt(index);

          isDeleting = false;

          showDeleteAnimation = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        notifications.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Image.asset(
                      Assets.assetsImagesBell,

                      width: 100,

                      height: 100,
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "No notifications",

                      style: TextStyle(
                        fontSize: 20,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : Skeletonizer(
                enabled: isDeleting,

                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),

                  itemCount: notifications.length,

                  itemBuilder: (context, index) {
                    final notification = notifications[index];

                    return Dismissible(
                      key: ValueKey(notification.id),

                      direction: DismissDirection.endToStart,

                      onDismissed: (direction) {
                        deleteNotification(index);
                      },

                      background: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),

                        alignment: Alignment.centerRight,

                        padding: const EdgeInsets.only(right: 20),

                        decoration: BoxDecoration(
                          color: Colors.red,

                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: const Icon(Icons.delete, color: Colors.white),
                      ),

                      child: NotificationItem(
                        notification: notification,
                        onTap: () {
                          setState(() {
                            notification.isRead = true;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),

        if (showDeleteAnimation)
          Center(
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                AppColors.kPrimaryColor,
                BlendMode.srcIn,
              ),
              child: Lottie.asset(
                "assets/animation/Smoke.json",
                width: 200,
                height: 200,

                repeat: false,
              ),
            ),
          ),
      ],
    );
  }
}
