import 'package:e_commerce/features/notification/domain/usecases/get_fav_notification.dart';
import 'package:e_commerce/features/notification/domain/usecases/get_read_notification.dart';
import 'package:e_commerce/features/notification/domain/usecases/get_unread_notification.dart';
import 'package:e_commerce/features/notification/domain/usecases/mark_notification_as_fav.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/notifications/socket_service.dart';
import '../../domain/entity/notification_entity.dart';
import '../../domain/usecases/delete_notification.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_as_read.dart';
import 'notification_state.dart';

const int pageSize = 20;

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotifications getNotifications;
  final GetReadNotifications getReadNotifications;
  final GetUnReadNotifications getUnReadNotifications;
  final GetFavNotifications getFavNotifications;
  final MarkNotificationAsRead markNotificationAsRead;
  final MarkNotificationAsFav markNotificationAsFav;
  final DeleteNotification deleteNotificationUseCase;

  final SocketService socketService;

  NotificationCubit({
    required this.getNotifications,
    required this.getReadNotifications,
    required this.markNotificationAsRead,
    required this.deleteNotificationUseCase,
    required this.socketService,
    required this.markNotificationAsFav,
    required this.getUnReadNotifications,
    required this.getFavNotifications,
  }) : super(const NotificationState());

  // ============================================================
  // FETCH
  // ============================================================

  Future<void> fetchAllNotifications() async {
    emit(
      state.copyWith(status: NotificationStatus.loading, errorMessage: null),
    );

    final result = await getNotifications(
      const GetNotificationsParams(offset: 0),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: NotificationStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (notifications) {
        final unreadCount = notifications
            .where((notification) => !notification.isRead)
            .length;

        emit(
          state.copyWith(
            status: NotificationStatus.loaded,
            notifications: notifications,
            unreadCount: unreadCount,
            hasReachedMax: notifications.length < pageSize,
          ),
        );
      },
    );
  }

  Future<void> fetchReadNotifications() async {
    emit(state.copyWith(status: NotificationStatus.loading));

    final result = await getReadNotifications(
      GetReadNotificationsParams(limit: 20, offset: 0),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: NotificationStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (notifications) {
        emit(
          state.copyWith(
            status: NotificationStatus.loaded,
            notifications: notifications,
          ),
        );
      },
    );
  }

  Future<void> fetchUnReadNotifications() async {
    emit(state.copyWith(status: NotificationStatus.loading));

    final result = await getUnReadNotifications(
      GetUnReadNotificationsParams(limit: 20, offset: 0),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: NotificationStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (notifications) {
        emit(
          state.copyWith(
            status: NotificationStatus.loaded,
            notifications: notifications,
          ),
        );
      },
    );
  }

  Future<void> fetchFavouriteNotifications() async {
    emit(state.copyWith(status: NotificationStatus.loading));

    final result = await getFavNotifications(
      GetFavNotificationsParams(limit: 20, offset: 0),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: NotificationStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (notifications) {
        emit(
          state.copyWith(
            status: NotificationStatus.loaded,
            notifications: notifications,
          ),
        );
      },
    );
  }

  // ============================================================
  // LOAD MORE
  // ============================================================

  Future<void> fetchMoreNotifications() async {
    if (state.hasReachedMax) {
      return;
    }

    if (state.status == NotificationStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(status: NotificationStatus.loadingMore));

    final result = await getNotifications(
      GetNotificationsParams(offset: state.notifications.length),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: NotificationStatus.loaded,
            errorMessage: failure.message,
          ),
        );
      },
      (moreNotifications) {
        final allNotifications = [...state.notifications, ...moreNotifications];

        final unreadCount = allNotifications
            .where((notification) => !notification.isRead)
            .length;

        emit(
          state.copyWith(
            status: NotificationStatus.loaded,
            notifications: allNotifications,
            unreadCount: unreadCount,
            hasReachedMax: moreNotifications.length < pageSize,
          ),
        );
      },
    );
  }

  // ============================================================
  // MARK AS READ
  // ============================================================

  Future<void> markAsRead(String notificationId) async {
    final notificationIndex = state.notifications.indexWhere(
      (notification) => notification.id == notificationId,
    );

    if (notificationIndex == -1) {
      return;
    }

    final notification = state.notifications[notificationIndex];

    if (notification.isRead) {
      return;
    }

    final updatedNotifications = List<NotificationEntity>.from(
      state.notifications,
    );

    updatedNotifications[notificationIndex] = notification.copyWith(
      isRead: true,
    );

    final unreadCount = updatedNotifications
        .where((notification) => !notification.isRead)
        .length;

    emit(
      state.copyWith(
        status: NotificationStatus.markingAsRead,
        notifications: updatedNotifications,
        unreadCount: unreadCount,
      ),
    );

    final result = await markNotificationAsRead(notificationId);

    result.fold(
      (failure) {
        // Rollback
        emit(
          state.copyWith(
            status: NotificationStatus.loaded,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        emit(state.copyWith(status: NotificationStatus.loaded));
      },
    );
  }

  Future<void> isFavourite(String notificationId) async {
    final notificationIndex = state.notifications.indexWhere(
      (notification) => notification.id == notificationId,
    );

    if (notificationIndex == -1) {
      return;
    }

    final notification = state.notifications[notificationIndex];

    // Keep the original list so we can restore it if the request fails.
    final originalNotifications = state.notifications;
    final originalFavouriteCount = state.IsFavouriteCount;

    final updatedNotifications = List<NotificationEntity>.from(
      state.notifications,
    );

    updatedNotifications[notificationIndex] = notification.copyWith(
      isFavourite: !notification.isFavourite,
    );

    final isFavouriteCount = updatedNotifications
        .where((notification) => notification.isFavourite)
        .length;

    emit(
      state.copyWith(
        status: NotificationStatus.markingAsFavourite,
        notifications: updatedNotifications,
        IsFavouriteCount: isFavouriteCount,
      ),
    );

    final result = await markNotificationAsFav(
      MarkNotificationAsFavParams(
        notificationId: notificationId,
        isFavourite: !notification.isFavourite,
      ),
    );

    result.fold(
      (failure) {
        // Rollback - restore the pre-toggle list and count.
        emit(
          state.copyWith(
            status: NotificationStatus.loaded,
            notifications: originalNotifications,
            IsFavouriteCount: originalFavouriteCount,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        emit(state.copyWith(status: NotificationStatus.loaded));
      },
    );
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<void> deleteNotification(String notificationId) async {
    final previous = state.notifications;

    final updated = previous
        .where((notification) => notification.id != notificationId)
        .toList();

    final unreadCount = updated
        .where((notification) => !notification.isRead)
        .length;

    emit(
      state.copyWith(
        status: NotificationStatus.deleting,
        notifications: updated,
        unreadCount: unreadCount,
      ),
    );

    final result = await deleteNotificationUseCase(notificationId);

    result.fold(
      (failure) {
        final previousUnreadCount = previous
            .where((notification) => !notification.isRead)
            .length;

        emit(
          state.copyWith(
            status: NotificationStatus.loaded,
            notifications: previous,
            unreadCount: previousUnreadCount,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        emit(state.copyWith(status: NotificationStatus.loaded));
      },
    );
  }

  // ============================================================
  // SOCKET
  // ============================================================

  void handleRealtimeNotification(NotificationEntity notification) {
    final exists = state.notifications.any(
      (item) => item.id == notification.id,
    );

    if (exists) {
      return;
    }

    final notifications = [notification, ...state.notifications];

    final unreadCount = notifications
        .where((notification) => !notification.isRead)
        .length;

    emit(
      state.copyWith(
        status: NotificationStatus.loaded,
        notifications: notifications,
        unreadCount: unreadCount,
      ),
    );
  }
}
