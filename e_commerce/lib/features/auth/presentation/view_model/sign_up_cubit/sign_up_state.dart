import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/auth/domain/entity/user_entity.dart';

abstract class SignUpState {}

class InitialState extends SignUpState {}

class LoadingState extends SignUpState {}

class FailureState extends SignUpState {
  final Failure failure;
  FailureState(this.failure);
}

class SuccessState extends SignUpState {
  final UserEntity user;
  SuccessState(this.user);
}
