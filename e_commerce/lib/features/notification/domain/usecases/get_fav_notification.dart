import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/use_case/use_case.dart';
import 'package:e_commerce/features/notification/domain/entity/notification_entity.dart';
import 'package:e_commerce/features/notification/domain/repo/notification_repository.dart';

class GetFavNotifications
    implements UseCase<List<NotificationEntity>, GetFavNotificationsParams> {
  const GetFavNotifications(this.repository);

  final NotificationRepository repository;

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
    GetFavNotificationsParams params,
  ) async {
    return await repository.getFavNotifications(
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetFavNotificationsParams {
  const GetFavNotificationsParams({
    required this.limit,
    required this.offset,
  });

  final int limit;
  final int offset;
}
