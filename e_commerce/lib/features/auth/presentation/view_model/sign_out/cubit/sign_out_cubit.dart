import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/helper_function/shared_prefs_helper.dart';
import 'package:e_commerce/features/auth/domain/use_case/log_out_use_case.dart';

part 'sign_out_state.dart';

class SignOutCubit extends Cubit<SignOutState> {
  final LogOutUseCase logOutUseCase;

  SignOutCubit(this.logOutUseCase) : super(SignOutInitial());

  Future<void> signOut() async {
    emit(SignOutInitial());
    final result = await logOutUseCase.call();
    result.fold((failure) => emit(SignOutFailure(failure)), (_) {
      SharedPrefsHelper.logout();
      emit(SignOutSuccess());
    });
  }
}
