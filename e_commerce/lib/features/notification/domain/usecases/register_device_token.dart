import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/use_case/use_case.dart';
import 'package:e_commerce/features/notification/domain/repo/notification_repository.dart';

class RegisterDeviceTokenParams {
  final String fcmToken;
  final String platform;
  const RegisterDeviceTokenParams({
    required this.fcmToken,
    required this.platform,
  });
}

class RegisterDeviceToken implements UseCase<void, RegisterDeviceTokenParams> {
  final NotificationRepository repository;
  RegisterDeviceToken(this.repository);

  @override
  Future<Either<Failure, void>> call(RegisterDeviceTokenParams params) {
    return repository.registerDeviceToken(
      fcmToken: params.fcmToken,
      platform: params.platform,
    );
  }
}
