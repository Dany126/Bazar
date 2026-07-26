import 'package:e_commerce/core/error/failure.dart';

abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordFailure extends ResetPasswordState {
  final Failure failure;

  ResetPasswordFailure(this.failure);
}
