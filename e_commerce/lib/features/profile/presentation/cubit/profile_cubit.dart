import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:e_commerce/features/auth/domain/entity/user_entity.dart';
import 'package:e_commerce/features/profile/domain/repository/profile_repository.dart';
import 'package:e_commerce/features/profile/domain/use_case/update_profile_use_case.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileCubit({required this.repository, required this.updateProfileUseCase})
    : super(const ProfileInitial());

  UserEntity? get currentUser {
    final currentState = state;

    if (currentState is ProfileLoaded) {
      return currentState.user;
    }

    if (currentState is ProfileUpdating) {
      return currentState.user;
    }

    if (currentState is ProfileUpdated) {
      return currentState.user;
    }

    return null;
  }

  void loadUser() {
    final result = repository.getCachedUser();

    result.fold(
      (failure) {
        emit(ProfileFailure(failure.message));
      },
      (user) {
        emit(ProfileLoaded(user));
      },
    );
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    File? image,
  }) async {
    final oldUser = currentUser;

    if (oldUser != null) {
      emit(ProfileUpdating(oldUser));
    } else {
      emit(const ProfileLoading());
    }

    final result = await updateProfileUseCase(
      name: name,
      email: email,
      phone: phone,
      image: image,
    );

    result.fold(
      (failure) {
        if (oldUser != null) {
          emit(ProfileLoaded(oldUser));
        } else {
          emit(ProfileFailure(failure.message));
        }
      },
      (updatedUser) {
        emit(ProfileUpdated(updatedUser));
      },
    );
  }
}
