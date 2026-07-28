part of 'sign_out_cubit.dart';

sealed class SignOutState {
  const SignOutState();
}

final class SignOutInitial extends SignOutState {}

final class SignOutSuccess extends SignOutState {
  const SignOutSuccess();
}

final class SignOutFailure extends SignOutState {
  final Failure failure;
  const SignOutFailure(this.failure);
}
