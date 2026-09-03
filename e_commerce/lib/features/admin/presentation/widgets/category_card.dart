import 'package:e_commerce/core/helper_function/fix_image_utl.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final bool selected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: selected ? const Color(0xffF0EEFF) : const Color(0xffFAFAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xff6C63FF)
                  : const Color(0xffECECF2),
            ),
          ),
          child: Row(
            children: [
              _CategoryImage(imageUrl: category.imageUrl),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: const Color(0xff252735),
                  ),
                ),
              ),

              if (selected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xff6C63FF),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryImage extends StatelessWidget {
  final String? imageUrl;

  const _CategoryImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final fixedUrl = fixImageUrl(imageUrl);

    return Container(
      width: 48,
      height: 48,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xffEEEEF5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: fixedUrl.isEmpty
          ? const _CategoryPlaceholder()
          : Image.network(
              fixedUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,

              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                return const Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },

              errorBuilder: (context, error, stackTrace) {
                debugPrint('CATEGORY IMAGE ERROR');
                debugPrint('URL: $fixedUrl');
                debugPrint('ERROR: $error');

                return const _CategoryPlaceholder();
              },
            ),
    );
  }
}

class _CategoryPlaceholder extends StatelessWidget {
  const _CategoryPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.category_outlined, color: Color(0xff8A8D9B)),
    );
  }
}
