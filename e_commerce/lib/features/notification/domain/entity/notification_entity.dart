class NotificationEntity {
  final String id;
  final String title;
  final String body;

  bool isRead;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    this.isRead = false,
  });
}
