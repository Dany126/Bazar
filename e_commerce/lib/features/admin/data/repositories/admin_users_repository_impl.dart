import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/data/datasources/admin_users_remote_data_source.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_user.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_users_repository.dart';

class AdminUsersRepositoryImpl implements AdminUsersRepository {
  final AdminUsersRemoteDataSource remoteDataSource;
  AdminUsersRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<AdminUser>>> getUsers() =>
      remoteDataSource.getUsers();
}
