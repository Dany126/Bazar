import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/use_case/use_case.dart';
import 'package:e_commerce/features/notification/domain/entity/notification_entity.dart';
import 'package:e_commerce/features/notification/domain/repo/notification_repository.dart';

class GetNotificationsParams {
  final int limit;
  final int offset;
  const GetNotificationsParams({this.limit = 20, this.offset = 0});
}

class GetNotifications
    implements UseCase<List<NotificationEntity>, GetNotificationsParams> {
  final NotificationRepository repository;
  GetNotifications(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
    GetNotificationsParams params,
  ) {
    return repository.getNotifications(
      limit: params.limit,
      offset: params.offset,
    );
  }
}
