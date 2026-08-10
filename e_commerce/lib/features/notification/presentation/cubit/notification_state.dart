import 'package:equatable/equatable.dart';

import '../../domain/entity/notification_entity.dart';

enum NotificationStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
  deleting,
  markingAsRead,
  markingAsFavourite,
}

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final bool hasReachedMax;
  final int IsFavouriteCount;
  final String? errorMessage;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.unreadCount = 0,
    this.hasReachedMax = false,
    this.errorMessage,
    this.IsFavouriteCount = 0,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationEntity>? notifications,
    int? unreadCount,
    bool? hasReachedMax,
    String? errorMessage,
    int? IsFavouriteCount,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      IsFavouriteCount: IsFavouriteCount ?? this.IsFavouriteCount,
    );
  }

  @override
  List<Object?> get props => [
    status,
    notifications,
    unreadCount,
    hasReachedMax,
    errorMessage,
    IsFavouriteCount,
  ];
}
