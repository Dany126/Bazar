import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String token;
  final String? imageUrl;
  final String role;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.token,
    required this.role,
    this.imageUrl,
  });

  bool get isAdmin => role.toUpperCase() == 'ADMIN';

  @override
  List<Object?> get props => [id, name, email, phone, token, imageUrl, role];
}
