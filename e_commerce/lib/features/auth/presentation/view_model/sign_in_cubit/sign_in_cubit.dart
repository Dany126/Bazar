import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/auth/domain/use_case/sign_in_usecase.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_in_cubit/sign_in_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInCubit extends Cubit<SignInState> {
  final SignInUsecase signInUsecase;

  SignInCubit({required this.signInUsecase}) : super(SignInInitial());

  Future<void> signIn({required String email, required String password}) async {
    emit(SignInLoading());

    try {
      final result = await signInUsecase.call(
        SignInParams(email: email, password: password),
      );

      result.fold(
        (failure) {
          emit(SignInError(failure));
        },
        (user) {
          emit(SignInSuccess(user));
        },
      );
    } catch (e) {
      emit(SignInError(_SimpleFailure(message: e.toString())));
    }
  }
}

// Local concrete implementation for abstract Failure
class _SimpleFailure extends Failure {
  const _SimpleFailure({required super.message});
}
