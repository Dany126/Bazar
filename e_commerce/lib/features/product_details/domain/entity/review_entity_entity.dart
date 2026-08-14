// lib/features/product_details/domin/entity/review_entity.dart
class ReviewEntity {
  final String id;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final DateTime? createdAt;

  const ReviewEntity({
    required this.id,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    this.createdAt,
  });
}
