import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/notification/domain/entity/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getUnReadNotifications({
    required int limit,
    required int offset,
  });
  Future<Either<Failure, List<NotificationEntity>>> getReadNotifications({
    required int limit,
    required int offset,
  });
  Future<Either<Failure, List<NotificationEntity>>> getFavNotifications({
    required int limit,
    required int offset,
  });
  Future<Either<Failure, List<NotificationEntity>>> getAllNotifications({
    required int limit,
    required int offset,
  });

  Future<Either<Failure, void>> markAsRead(String notificationId);

  Future<Either<Failure, void>> registerDeviceToken({
    required String fcmToken,
    required String platform,
  });

  Future<Either<Failure, void>> deleteNotification(String notificationId);

  Future<Either<Failure, void>> markAsFav(
    String notificationId,
    bool isFavourite,
  );
}
