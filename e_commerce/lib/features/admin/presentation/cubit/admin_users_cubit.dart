import 'package:e_commerce/features/admin/domain/entity/admin_user.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_admin_users.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AdminUsersState {
  const AdminUsersState();
}

class AdminUsersInitial extends AdminUsersState {}

class AdminUsersLoading extends AdminUsersState {}

class AdminUsersLoaded extends AdminUsersState {
  final List<AdminUser> users;
  const AdminUsersLoaded(this.users);
}

class AdminUsersFailure extends AdminUsersState {
  final String message;
  const AdminUsersFailure(this.message);
}

class AdminUsersCubit extends Cubit<AdminUsersState> {
  final GetAdminUsersUseCase useCase;
  AdminUsersCubit({required this.useCase}) : super(AdminUsersInitial());
  Future<void> load() async {
    emit(AdminUsersLoading());
    final r = await useCase();
    r.fold(
      (f) => emit(AdminUsersFailure(f.message)),
      (u) => emit(AdminUsersLoaded(u)),
    );
  }
}
