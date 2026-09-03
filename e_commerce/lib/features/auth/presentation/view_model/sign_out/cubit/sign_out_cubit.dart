import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/helper_function/shared_prefs_helper.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/auth/domain/use_case/log_out_use_case.dart';

part 'sign_out_state.dart';

class SignOutCubit extends Cubit<SignOutState> {
  final LogOutUseCase logOutUseCase;
  final ApiService apiService;

  SignOutCubit({required this.logOutUseCase, required this.apiService})
    : super(const SignOutInitial());

  Future<void> signOut() async {
    if (state is SignOutLoading) {
      return;
    }

    emit(const SignOutLoading());

    /*
     * IMPORTANT:
     *
     * Logout must NOT depend on the logout API succeeding.
     *
     * The local session is cleared first.
     * This prevents the refresh interceptor from keeping
     * the user stuck on the dashboard.
     */

    try {
      await apiService.clearAuthTokens();
    } catch (e) {
      // Local token cleanup should never stop logout.
      print('LOCAL AUTH CLEAR ERROR: $e');
    }

    try {
      await SharedPrefsHelper.logout();
    } catch (e) {
      print('SHARED PREFS LOGOUT ERROR: $e');
    }

    /*
     * At this point the user is already logged out locally.
     *
     * We can notify the backend, but we DO NOT wait for it.
     *
     * This request is intentionally fire-and-forget.
     */
    _notifyServerLogout();

    emit(const SignOutSuccess());
  }

  Future<void> _notifyServerLogout() async {
    try {
      await logOutUseCase.call();
    } catch (e) {
      print('SERVER LOGOUT FAILED: $e');
    }
  }
}
