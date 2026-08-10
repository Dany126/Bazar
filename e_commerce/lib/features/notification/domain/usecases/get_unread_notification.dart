import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/use_case/use_case.dart';
import 'package:e_commerce/features/notification/domain/entity/notification_entity.dart';
import 'package:e_commerce/features/notification/domain/repo/notification_repository.dart';

class GetUnReadNotifications
    implements UseCase<List<NotificationEntity>, GetUnReadNotificationsParams> {
  const GetUnReadNotifications(this.repository);

  final NotificationRepository repository;

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
    GetUnReadNotificationsParams params,
  ) async {
    return await repository.getUnReadNotifications(
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetUnReadNotificationsParams {
  const GetUnReadNotificationsParams({
    required this.limit,
    required this.offset,
  });

  final int limit;
  final int offset;
}
