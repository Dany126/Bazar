import 'package:dartz/dartz.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/notification/domain/entity/notification_entity.dart';
import 'package:e_commerce/features/notification/domain/repo/notification_repository.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final ApiService apiService;
  NotificationRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    required int limit,
    required int offset,
  }) async {
    final result = await apiService.get(
      '$kBaseUrl/notification',
      // queryParameters: {'limit': limit, 'offset': offset},
    );

    return result.fold(
      (failure) => Left(failure),
      (data) => Right(
        (data as List).map((json) => NotificationModel.fromJson(json)).toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    final result = await apiService.patch('/notification/$notificationId/read');
    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    final result = await apiService.get('/notification/unread-count');
    return result.fold(
      (failure) => Left(failure),
      (data) => Right(data['count'] as int),
    );
  }

  @override
  Future<Either<Failure, void>> registerDeviceToken({
    required String fcmToken,
    required String platform,
  }) async {
    final result = await apiService.post(
      '/device-tokens',
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
