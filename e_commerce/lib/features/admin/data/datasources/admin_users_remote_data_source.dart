import 'package:dartz/dartz.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_user.dart';

abstract class AdminUsersRemoteDataSource {
  Future<Either<Failure, List<AdminUser>>> getUsers();
}
class AdminUsersRemoteDataSourceImpl implements AdminUsersRemoteDataSource {
  final ApiService apiService;
  AdminUsersRemoteDataSourceImpl({required this.apiService});
  @override
  Future<Either<Failure, List<AdminUser>>> getUsers() async {
    final result = await apiService.get('$kBaseUrl/user');
    return result.fold((failure) => Left(failure), (json) {
      final list = (json['users'] as List?) ?? [];
      return Right(list.whereType<Map>().map((e) => AdminUser(
        id: '${e['_id'] ?? e['id'] ?? ''}',
        name: '${e['name'] ?? ''}',
        email: '${e['email'] ?? ''}',
        role: '${e['role'] ?? ''}',
        phone: e['phone']?.toString(),
      )).toList());
    });
  }
}
