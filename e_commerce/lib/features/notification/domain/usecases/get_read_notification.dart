import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/use_case/use_case.dart';
import 'package:e_commerce/features/notification/domain/entity/notification_entity.dart';
import 'package:e_commerce/features/notification/domain/repo/notification_repository.dart';

class GetReadNotifications
    implements UseCase<List<NotificationEntity>, GetReadNotificationsParams> {
  const GetReadNotifications(this.repository);

  final NotificationRepository repository;

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
    GetReadNotificationsParams params,
  ) async {
    return await repository.getReadNotifications(
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetReadNotificationsParams {
  const GetReadNotificationsParams({required this.limit, required this.offset});

  final int limit;
  final int offset;
}
