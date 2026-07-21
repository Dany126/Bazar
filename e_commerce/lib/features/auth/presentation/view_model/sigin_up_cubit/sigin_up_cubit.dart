import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/auth/domain/entity/user_entity.dart';
import 'package:e_commerce/features/auth/domain/use_case/sign_up_usecase.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sigin_up_cubit/sigin_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SiginUpCubit extends Cubit<SiginUpState> {
  final SignUpUsecase signUpUsecase;

  SiginUpCubit({required this.signUpUsecase}) : super(InitialState());

  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    emit(LoadingState());

    final result = await signUpUsecase.call(
      SignUpParams(email: email, password: password, name: name, phone: phone),
    );

    result.fold(
      (failure) {
        emit(FailureState(failure));
      },
      (user) {
        emit(SuccessState(user));
      },
    );

    return result;
  }
}
