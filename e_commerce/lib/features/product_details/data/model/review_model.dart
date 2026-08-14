// lib/features/product_details/data/model/review_model.dart

import 'package:e_commerce/features/product_details/domain/entity/review_entity_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.userName,
    super.userAvatar,
    required super.rating,
    required super.comment,
    super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'] ?? json['id'] ?? '',
      userName: json['userName'] ?? json['user']?['name'] ?? 'Anonymous',
      userAvatar: json['userAvatar'] ?? json['user']?['avatar'],
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
