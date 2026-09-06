import 'package:e_commerce/features/auth/domain/entity/user_entity.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final UserEntity user;

  const ProfileLoaded(this.user);
}

class ProfileUpdating extends ProfileState {
  final UserEntity user;

  const ProfileUpdating(this.user);
}

class ProfileUpdated extends ProfileState {
  final UserEntity user;

  const ProfileUpdated(this.user);
}

class ProfileFailure extends ProfileState {
  final String message;

  const ProfileFailure(this.message);
}
