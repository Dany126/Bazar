import 'package:e_commerce/core/services/hive_server.dart';

String? get cachedUserId {
  final userMap = HiveService.authBox.get('user');
  if (userMap == null) return null;
  return Map<String, dynamic>.from(userMap)['id'] as String?;
}
