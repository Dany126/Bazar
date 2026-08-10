import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../../constant.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/services/api_services.dart';
import '../../domain/repo/notification_repository.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final ApiService apiService;

  NotificationRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, List<NotificationModel>>> getUnReadNotifications({
    required int limit,
    required int offset,
  }) async {
    final result = await apiService.get(
      '$kBaseUrl/notification',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        'sort': '-createdAt',
        'isRead': false,
      },
    );

    return result.fold((failure) => Left(failure), (data) {
      log('NOTIFICATION RESPONSE: $data');

      if (data is! Map) {
        return Left(ServerFailure(message: 'Invalid notification response'));
      }

      final notificationsData = data['notifications'];

      if (notificationsData is! List) {
        return Left(ServerFailure(message: 'notifications is not a List'));
      }

      try {
        final notifications = notificationsData
            .map(
              (json) => NotificationModel.fromJson(
                Map<String, dynamic>.from(json as Map),
              ),
            )
            .toList();

        return Right(notifications);
      } catch (e) {
        log('Notification parsing error: $e');

        return Left(ServerFailure(message: 'Failed to parse notifications'));
      }
    });
  }

  @override
  Future<Either<Failure, List<NotificationModel>>> getReadNotifications({
    required int limit,
    required int offset,
  }) async {
    final result = await apiService.get(
      '$kBaseUrl/notification',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        'sort': '-createdAt',
        'isRead': true,
      },
    );

    return result.fold((failure) => Left(failure), (data) {
      log('NOTIFICATION RESPONSE: $data');

      if (data is! Map) {
        return Left(ServerFailure(message: 'Invalid notification response'));
      }

      final notificationsData = data['notifications'];

      if (notificationsData is! List) {
        return Left(ServerFailure(message: 'notifications is not a List'));
      }

      try {
        final notifications = notificationsData
            .map(
              (json) => NotificationModel.fromJson(
                Map<String, dynamic>.from(json as Map),
              ),
            )
            .toList();

        return Right(notifications);
      } catch (e) {
        log('Notification parsing error: $e');

        return Left(ServerFailure(message: 'Failed to parse notifications'));
      }
    });
  }

  @override
  Future<Either<Failure, List<NotificationModel>>> getFavNotifications({
    required int limit,
    required int offset,
  }) async {
    final result = await apiService.get(
      '$kBaseUrl/notification',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        'sort': '-createdAt',
        'isFavourite': true,
      },
    );

    return result.fold((failure) => Left(failure), (data) {
      log('NOTIFICATION RESPONSE: $data');

      if (data is! Map) {
        return Left(ServerFailure(message: 'Invalid notification response'));
      }

      final notificationsData = data['notifications'];

      if (notificationsData is! List) {
        return Left(ServerFailure(message: 'notifications is not a List'));
      }

      try {
        final notifications = notificationsData
            .map(
              (json) => NotificationModel.fromJson(
                Map<String, dynamic>.from(json as Map),
              ),
            )
            .toList();

        return Right(notifications);
      } catch (e) {
        log('Notification parsing error: $e');

        return Left(ServerFailure(message: 'Failed to parse notifications'));
      }
    });
  }

  @override
  Future<Either<Failure, List<NotificationModel>>> getAllNotifications({
    required int limit,
    required int offset,
  }) async {
    final result = await apiService.get(
      '$kBaseUrl/notification',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        'sort': '-createdAt',
        'isFavourite': true,
      },
    );

    return result.fold((failure) => Left(failure), (data) {
      log('NOTIFICATION RESPONSE: $data');

      if (data is! Map) {
        return Left(ServerFailure(message: 'Invalid notification response'));
      }

      final notificationsData = data['notifications'];

      if (notificationsData is! List) {
        return Left(ServerFailure(message: 'notifications is not a List'));
      }

      try {
        final notifications = notificationsData
            .map(
              (json) => NotificationModel.fromJson(
                Map<String, dynamic>.from(json as Map),
              ),
            )
            .toList();

        return Right(notifications);
      } catch (e) {
        log('Notification parsing error: $e');

        return Left(ServerFailure(message: 'Failed to parse notifications'));
      }
    });
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    final result = await apiService.patch(
      '$kBaseUrl/notification/$notificationId',
      data: {'isRead': true},
    );

    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<Failure, void>> markAsFav(
    String notificationId,
    bool isFavourite,
  ) async {
    final result = await apiService.patch(
      '$kBaseUrl/notification/$notificationId',
      data: {'isFavourite': isFavourite},
    );

    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<Failure, void>> registerDeviceToken({
    required String fcmToken,
    required String platform,
  }) async {
    final result = await apiService.post(
      '$kBaseUrl/device-tokens',
      data: {'fcmToken': fcmToken, 'platform': platform},
    );

    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<Failure, void>> deleteNotification(
    String notificationId,
  ) async {
    final result = await apiService.delete(
      '$kBaseUrl/notification/$notificationId',
    );

    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }
}
