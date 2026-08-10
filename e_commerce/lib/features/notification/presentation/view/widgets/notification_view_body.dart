import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/notification/domain/entity/notification_entity.dart';
import 'package:e_commerce/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:e_commerce/features/notification/presentation/cubit/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'notification_item.dart';

class NotificationViewBody extends StatefulWidget {
  const NotificationViewBody({super.key});

  @override
  State<NotificationViewBody> createState() => _NotificationViewBodyState();
}

class _NotificationViewBodyState extends State<NotificationViewBody> {
  bool showDeleteAnimation = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        // ======================================================
        // LOADING
        // ======================================================

        if (state.status == NotificationStatus.initial ||
            state.status == NotificationStatus.loading) {
          return Skeletonizer(
            enabled: true,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: 6,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SizedBox(height: 80, child: Card()),
                );
              },
            ),
          );
        }

        // ======================================================
        // ERROR
        // ======================================================

        if (state.status == NotificationStatus.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'Something went wrong',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NotificationCubit>().fetchNotifications();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final notifications = state.notifications;

        // ======================================================
        // EMPTY
        // ======================================================

        if (notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Assets.assetsImagesBell, width: 100, height: 100),
                const SizedBox(height: 30),
                const Text(
                  'No notifications',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }

        // ======================================================
        // LIST
        // ======================================================

        return Stack(
          children: [
            NotificationListView(
              notifications: notifications,
              onDelete: (id) {
                setState(() {
                  showDeleteAnimation = true;
                });

                Future.delayed(const Duration(seconds: 1), () {
                  if (!mounted) return;

                  context.read<NotificationCubit>().deleteNotification(id);

                  setState(() {
                    showDeleteAnimation = false;
                  });
                });
              },
            ),

            // ==================================================
            // LOADING MORE
            // ==================================================
            if (state.status == NotificationStatus.loadingMore)
              const Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(child: CircularProgressIndicator()),
              ),

            // ==================================================
            // DELETE ANIMATION
            // ==================================================
            if (showDeleteAnimation)
              Center(
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    AppColors.kPrimaryColor,
                    BlendMode.srcIn,
                  ),
                  child: Lottie.asset(
                    'assets/animation/Smoke.json',
                    width: 200,
                    height: 200,
                    repeat: false,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

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
          ),
        );
      },
    );
  }
}
