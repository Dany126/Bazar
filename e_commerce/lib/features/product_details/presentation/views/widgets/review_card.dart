// lib/features/product_details/presenation/view/widgets/review_card.dart
import 'package:e_commerce/features/product_details/domain/entity/review_entity_entity.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});

  final ReviewEntity review;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey[300],
          backgroundImage: review.userAvatar != null
              ? NetworkImage(review.userAvatar!)
              : null,
          child: review.userAvatar == null
              ? Text(review.userName.isNotEmpty ? review.userName[0] : '?')
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    review.userName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < review.rating.round()
                            ? Icons.star
                            : Icons.star_border,
                        size: 14,
                        color: Colors.amber,
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                review.comment,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              if (review.createdAt != null) ...[
                const SizedBox(height: 4),
                Text(
                  _timeAgo(review.createdAt!),
                  style: const TextStyle(fontSize: 11, color: Colors.black38),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return 'just now';
  }
}
