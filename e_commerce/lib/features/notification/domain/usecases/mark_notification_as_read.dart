import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/use_case/use_case.dart';
import 'package:e_commerce/features/notification/domain/repo/notification_repository.dart';

class MarkNotificationAsRead implements UseCase<void, String> {
  final NotificationRepository repository;
  MarkNotificationAsRead(this.repository);

  @override
  Future<Either<Failure, void>> call(String notificationId) {
    return repository.markAsRead(notificationId);
  }
}
