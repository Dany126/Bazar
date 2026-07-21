import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:e_commerce/features/auth/presentation/view_model/reset_password/reset_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this.resetPasswordUsecase) : super(ResetPasswordInitial());
  ResetPasswordUsecase resetPasswordUsecase;

  Future<Either<Failure, void>> resetPassword({required String email}) async {
    emit(ResetPasswordInitial());
    final result = await resetPasswordUsecase.call(email);
    result.fold(
      (failure) => emit(ResetPasswordFailure(failure)),
      (_) => emit(ResetPasswordSuccess()),
    );
    return result;
  }
}
