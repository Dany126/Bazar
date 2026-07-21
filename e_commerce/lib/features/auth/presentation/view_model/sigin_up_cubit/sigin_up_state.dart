import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/auth/domain/entity/user_entity.dart';

abstract class SiginUpState {}

class InitialState extends SiginUpState {}

class LoadingState extends SiginUpState {}

class FailureState extends SiginUpState {
  final Failure failure;
  FailureState(this.failure);
}

class SuccessState extends SiginUpState {
  final UserEntity user;
  SuccessState(this.user);
}
