import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_user.dart';
abstract class AdminUsersRepository { Future<Either<Failure, List<AdminUser>>> getUsers(); }
