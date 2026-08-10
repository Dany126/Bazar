import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/use_case/use_case.dart';
import 'package:e_commerce/features/notification/domain/repo/notification_repository.dart';

class MarkNotificationAsFavParams {
  final String notificationId;
  final bool isFavourite;

  MarkNotificationAsFavParams({
    required this.notificationId,
    required this.isFavourite,
  });
}

class MarkNotificationAsFav implements UseCase<void, MarkNotificationAsFavParams> {
  final NotificationRepository repository;
  MarkNotificationAsFav(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkNotificationAsFavParams params) {
    return repository.markAsFav(params.notificationId, params.isFavourite);
  }
}
