import 'dart:async';

import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/core/widgets/custom_button.dart';
import 'package:e_commerce/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:e_commerce/features/notification/presentation/cubit/notification_state.dart';
import 'package:e_commerce/features/notification/presentation/view/widgets/notification_filter_bar.dart';
import 'package:e_commerce/features/notification/presentation/view/widgets/notification_list_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum NotificationFilter { all, read, unread, favourite }

class NotificationViewBody extends StatefulWidget {
  const NotificationViewBody({super.key});

  @override
  State<NotificationViewBody> createState() => _NotificationViewBodyState();
}

class _NotificationViewBodyState extends State<NotificationViewBody> {
  bool showDeleteAnimation = false;

  NotificationFilter selectedFilter = NotificationFilter.all;

  StreamSubscription<RemoteMessage>? _fcmSubscription;
  StreamSubscription<RemoteMessage>? _fcmOpenedSubscription;

  @override
  void initState() {
    super.initState();

    _listenToFCM();
    _checkInitialMessage();
  }

  void _listenToFCM() {
    // App is open and in the foreground when the notification arrives.
    _fcmSubscription = FirebaseMessaging.onMessage.listen((
      RemoteMessage message,
    ) {
      if (!mounted) return;

      // FCM received a new notification - refresh using whichever
      // filter is currently selected, so the visible list stays correct.
      _refreshCurrentFilter();
    });

    // App was in the background and the user tapped the notification.
    _fcmOpenedSubscription = FirebaseMessaging.onMessageOpenedApp.listen((
      RemoteMessage message,
    ) {
      debugPrint('================================');
      debugPrint('FCM notification opened app (background)');
      debugPrint('Data: ${message.data}');
      debugPrint('================================');

      if (!mounted) return;

      _refreshCurrentFilter();
    });
  }

  // App was fully closed/terminated and the user tapped the notification.
  Future<void> _checkInitialMessage() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null && mounted) {
      debugPrint('================================');
      debugPrint('App opened from terminated state via notification');
      debugPrint('Data: ${initialMessage.data}');
      debugPrint('================================');

      _refreshCurrentFilter();
    }
  }

  void _refreshCurrentFilter() {
    switch (selectedFilter) {
      case NotificationFilter.all:
        context.read<NotificationCubit>().fetchAllNotifications();
      case NotificationFilter.read:
        context.read<NotificationCubit>().fetchReadNotifications();
      case NotificationFilter.unread:
        context.read<NotificationCubit>().fetchUnReadNotifications();
      case NotificationFilter.favourite:
        context.read<NotificationCubit>().fetchFavouriteNotifications();
    }
  }

  void _onFilterSelected(NotificationFilter filter) {
    if (filter == selectedFilter) return;

    setState(() {
      selectedFilter = filter;
    });

    switch (filter) {
      case NotificationFilter.all:
        context.read<NotificationCubit>().fetchAllNotifications();
      case NotificationFilter.read:
        context.read<NotificationCubit>().fetchReadNotifications();
      case NotificationFilter.unread:
        context.read<NotificationCubit>().fetchUnReadNotifications();
      case NotificationFilter.favourite:
        context.read<NotificationCubit>().fetchFavouriteNotifications();
    }
  }

  String get _emptyMessage {
    switch (selectedFilter) {
      case NotificationFilter.all:
        return 'No notifications';
      case NotificationFilter.read:
        return 'No read notifications';
      case NotificationFilter.unread:
        return 'No unread notifications';
      case NotificationFilter.favourite:
        return 'No favourite notifications';
    }
  }

  @override
  void dispose() {
    _fcmSubscription?.cancel();
    _fcmOpenedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NotificationFilterBar(
          selectedFilter: selectedFilter,
          onFilterSelected: _onFilterSelected,
        ),
        Expanded(
          child: BlocConsumer<NotificationCubit, NotificationState>(
            listener: (context, state) {
              if (state.status == NotificationStatus.deleting) {
                setState(() {
                  showDeleteAnimation = true;
                });
              }

              if (state.status == NotificationStatus.loaded) {
                setState(() {
                  showDeleteAnimation = false;
                });
              }
            },

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
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
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
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.errorMessage ?? 'Something went wrong',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          onTap: _refreshCurrentFilter,
                          text: 'Retry',
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
                      Image.asset(
                        Assets.assetsImagesBell,
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        _emptyMessage,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (selectedFilter != NotificationFilter.all) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: CustomButton(
                            onTap: () =>
                                _onFilterSelected(NotificationFilter.all),
                            text: 'Explore All',
                          ),
                        ),
                      ],
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

                        context.read<NotificationCubit>().deleteNotification(
                          id,
                        );
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
          ),
        ),
      ],
    );
  }
}
