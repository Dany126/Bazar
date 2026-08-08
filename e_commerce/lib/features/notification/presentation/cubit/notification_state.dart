import 'package:e_commerce/features/notification/domain/entity/notification_entity.dart';
import 'package:equatable/equatable.dart';

enum NotificationStatus { initial, loading, loaded, loadingMore, error }

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final bool hasReachedMax;
  final String? errorMessage;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.unreadCount = 0,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationEntity>? notifications,
    int? unreadCount,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    notifications,
    unreadCount,
    hasReachedMax,
    errorMessage,
  ];
}
