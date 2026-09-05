import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_user.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_users_repository.dart';
class GetAdminUsersUseCase { final AdminUsersRepository repository; const GetAdminUsersUseCase(this.repository); Future<Either<Failure,List<AdminUser>>> call() => repository.getUsers(); }
