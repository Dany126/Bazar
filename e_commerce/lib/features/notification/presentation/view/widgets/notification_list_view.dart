import 'package:e_commerce/features/notification/domain/entity/notification_entity.dart';
import 'package:e_commerce/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:e_commerce/features/notification/presentation/view/widgets/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationListView extends StatelessWidget {
  final List<NotificationEntity> notifications;

  final void Function(String id) onDelete;

  const NotificationListView({
    super.key,
    required this.notifications,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];

        return Dismissible(
          key: ValueKey(notification.id),
          direction: DismissDirection.endToStart,

          confirmDismiss: (_) async {
            onDelete(notification.id);

            return false;
          },

          background: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              context.read<NotificationCubit>().markAsRead(notification.id);
            },
            onTapStar: () {
              context.read<NotificationCubit>().isFavourite(notification.id);
            },
          ),
        );
      },
    );
  }
}
