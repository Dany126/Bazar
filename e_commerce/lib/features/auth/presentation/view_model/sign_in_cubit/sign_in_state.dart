import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/auth/domain/entity/user_entity.dart';

abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInError extends SignInState {
  final Failure failure;
  SignInError(this.failure);
}

class SignInSuccess extends SignInState {
  final UserEntity user;
  SignInSuccess(this.user);
}
