import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/notification/domain/entity/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    required int limit,
    required int offset,
  });

  Future<Either<Failure, void>> markAsRead(String notificationId);

  Future<Either<Failure, int>> getUnreadCount();

  Future<Either<Failure, void>> registerDeviceToken({
    required String fcmToken,
    required String platform,
  });

  Future<Either<Failure, void>> deleteNotification(String notificationId);
}
