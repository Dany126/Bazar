class AdminUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  const AdminUser({required this.id, required this.name, required this.email, required this.role, this.phone});
}
