import 'package:e_commerce/features/notification/domain/entity/notification_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/notifications/socket_service.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_as_read.dart';
import '../../domain/usecases/delete_notification.dart';
import 'notification_state.dart';

const _pageSize = 20;

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

  Future<void> fetchNotifications() async {
    emit(state.copyWith(status: NotificationStatus.loading));

    final result = await getNotifications(const GetNotificationsParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (notifications) => emit(
        state.copyWith(
          status: NotificationStatus.loaded,
          notifications: notifications,
          unreadCount: notifications.where((n) => !n.isRead).length,
          hasReachedMax: notifications.length < _pageSize,
        ),
      ),
    );
  }

  Future<void> fetchMoreNotifications() async {
    if (state.hasReachedMax || state.status == NotificationStatus.loadingMore) {
      return;
    }
    emit(state.copyWith(status: NotificationStatus.loadingMore));

    final result = await getNotifications(
      GetNotificationsParams(offset: state.notifications.length),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (more) => emit(
        state.copyWith(
          status: NotificationStatus.loaded,
          notifications: [...state.notifications, ...more],
          hasReachedMax: more.length < _pageSize,
        ),
      ),
    );
  }

  Future<void> markAsRead(String notificationId) async {
    final updated = state.notifications
        .map((n) => n.id == notificationId ? n.copyWith(isRead: true) : n)
        .toList();
    emit(
      state.copyWith(
        notifications: updated,
        unreadCount: updated.where((n) => !n.isRead).length,
      ),
    );
    await markNotificationAsRead(notificationId);
  }

  Future<void> deleteNotification(String notificationId) async {
    final previous = state.notifications;
    final updated = previous.where((n) => n.id != notificationId).toList();

    emit(
      state.copyWith(
        notifications: updated,
        unreadCount: updated.where((n) => !n.isRead).length,
      ),
    );

    final result = await deleteNotificationUseCase(notificationId);

    result.fold(
      // rollback if the server delete failed, so UI doesn't lie about state
      (failure) => emit(
        state.copyWith(
          notifications: previous,
          unreadCount: previous.where((n) => !n.isRead).length,
          errorMessage: failure.message,
        ),
      ),
      (_) => null,
    );
  }

  /// Called by main.dart wiring when the socket emits a live 'notification' event.
  void handleRealtimeNotification(NotificationEntity notification) {
    emit(
      state.copyWith(
        notifications: [notification, ...state.notifications],
        unreadCount: state.unreadCount + 1,
      ),
    );
  }
}
