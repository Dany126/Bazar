import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic> data;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.data,
    required this.isRead,
    required this.createdAt,
  });

  NotificationEntity copyWith({bool? isRead}) => NotificationEntity(
    id: id,
    title: title,
    body: body,
    type: type,
    data: data,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt,
  );

  @override
  List<Object?> get props => [id, title, body, type, data, isRead, createdAt];
}
