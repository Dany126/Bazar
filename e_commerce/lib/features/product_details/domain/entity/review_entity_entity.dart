class ReviewEntity {
  final String id;
  final String description;
  final double rating;
  final String userId;
  final String productId;
  final DateTime? createdAt;

  const ReviewEntity({
    required this.id,
    required this.description,
    required this.rating,
    required this.userId,
    required this.productId,
    this.createdAt,
  });
}