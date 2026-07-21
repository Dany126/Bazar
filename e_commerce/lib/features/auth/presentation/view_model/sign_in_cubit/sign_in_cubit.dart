import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/auth/domain/entity/user_entity.dart';
import 'package:e_commerce/features/auth/domain/use_case/sign_in_usecase.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_in_cubit/sign_in_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({required this.signInUsecase}) : super(SignInInitial());
  final SignInUsecase signInUsecase;

  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    emit(SignInLoading());
    final result = await signInUsecase(
      SignInParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(SignInError(failure)),
      (user) => emit(SignInSuccess(user)),
    );
    return result;
  }
}
