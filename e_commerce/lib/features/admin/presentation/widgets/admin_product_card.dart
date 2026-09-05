import 'package:e_commerce/core/helper_function/fix_image_utl.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:flutter/material.dart';

class AdminProductCard extends StatelessWidget {
  final ProductModel product;

  const AdminProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final imageUrl = fixImageUrl(product.thumbnailUrl);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffE8EAF0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xffF5F5F8),
              child: imageUrl.isEmpty
                  ? const _ProductImagePlaceholder()
                  : Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,

                      // Prevent broken image exceptions
                      // from breaking the card.
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('PRODUCT IMAGE ERROR');
                        debugPrint('URL: $imageUrl');
                        debugPrint('ERROR: $error');

                        return const _ProductImagePlaceholder();
                      },

                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return const Center(
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                    ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff20222F),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff6C63FF),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Stock: ${product.stock}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff858897),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductImagePlaceholder extends StatelessWidget {
  const _ProductImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.image_outlined, size: 45, color: Color(0xffB0B2BD)),
    );
  }
}
