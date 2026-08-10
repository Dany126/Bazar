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
  final MarkNotificationAsRead markNotificationAsRead;
  final DeleteNotification deleteNotificationUseCase;
  final SocketService socketService;

  NotificationCubit({
    required this.getNotifications,
    required this.markNotificationAsRead,
    required this.deleteNotificationUseCase,
    required this.socketService,
  }) : super(const NotificationState());

  // ============================================================
  // FETCH
  // ============================================================

  Future<void> fetchNotifications() async {
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
