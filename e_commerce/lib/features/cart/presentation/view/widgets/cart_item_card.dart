// lib/features/cart/presenation/view/widgets/cart_item_card.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/core/helper_function/fix_image_utl.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/features/cart/domain/entity/cart_item_entity.dart';
import 'package:flutter/material.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onRemove,
    this.onDecrement,
  });

  final CartItemEntity item;
  final VoidCallback onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final bool isSmallScreen = screenWidth < 360;
    final double imageSize = isSmallScreen ? 70 : 82;

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),

      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 26),
      ),

      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
        decoration: BoxDecoration(
          color: AppColors.kCardBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= IMAGE =================
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: fixImageUrl(item.image ?? ''),
                width: imageSize,
                height: imageSize,
                fit: BoxFit.fitHeight,

                placeholder: (context, url) {
                  return SizedBox(
                    width: imageSize,
                    height: imageSize,
                    child: const Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                },

                errorWidget: (context, url, error) {
                  return Container(
                    width: imageSize,
                    height: imageSize,
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey.shade500,
                    ),
                  );
                },
              ),
            ),

            SizedBox(width: isSmallScreen ? 8 : 12),

            // ================= CONTENT =================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name + price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.textStylesRegular16(
                            context,
                          ).copyWith(color: Colors.black),
                        ),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        '\$${((item.price ?? 0) * item.quantity).toStringAsFixed(0)}',
                        style: AppStyles.textStylesBold16Mono(context),
                      ),
                      const SizedBox(width: 6),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ================= VARIANT INFO =================
                  _buildVariantInfo(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // VARIANT INFO
  // ============================================================

  Widget _buildVariantInfo(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (item.size != null && item.size!.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Size:',
                style: AppStyles.textStylesRegular14(
                  context,
                ).copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(width: 4),
              Text(item.size!, style: AppStyles.textStylesSemiBold14(context)),
            ],
          ),

        if (item.color != null && item.color!.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Color:',
                style: AppStyles.textStylesRegular14(
                  context,
                ).copyWith(color: Colors.grey.shade600),
              ),

              const SizedBox(width: 5),

              // Actual color circle
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: _colorFromName(item.color!),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade400, width: 0.8),
                ),
              ),

              Expanded(child: _buildQuantityController(context)),
            ],
          ),
      ],
    );
  }

  // ============================================================
  // QUANTITY CONTROLLER
  // ============================================================

  Widget _buildQuantityController(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.transparent,

        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          _stepperButton(
            icon: Icons.remove,
            onTap: item.quantity > 1 ? onDecrement : null,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              item.quantity.toString(),
              style: AppStyles.textStylesSemiBold14(context),
            ),
          ),

          _stepperButton(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }

  // ============================================================
  // STEPPER BUTTON
  // ============================================================

  Widget _stepperButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    final bool enabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: enabled ? AppColors.kPrimaryAccentColor : Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? Colors.white : Colors.grey.shade500,
        ),
      ),
    );
  }

  // ============================================================
  // COLOR NAME -> FLUTTER COLOR
  // ============================================================

  Color _colorFromName(String colorName) {
    switch (colorName.trim().toLowerCase()) {
      // Basic colors
      case 'red':
        return Colors.red;

      case 'blue':
        return Colors.blue;

      case 'green':
        return Colors.green;

      case 'yellow':
        return Colors.yellow;

      case 'orange':
        return Colors.orange;

      case 'purple':
        return Colors.purple;

      case 'pink':
        return Colors.pink;

      case 'brown':
        return Colors.brown;

      case 'black':
        return Colors.black;

      case 'white':
        return Colors.white;

      case 'grey':
      case 'gray':
        return Colors.grey;

      // Additional colors
      case 'cyan':
        return Colors.cyan;

      case 'teal':
        return Colors.teal;

      case 'indigo':
        return Colors.indigo;

      case 'lime':
        return Colors.lime;

      case 'amber':
        return Colors.amber;

      case 'deep orange':
        return Colors.deepOrange;

      case 'deep purple':
        return Colors.deepPurple;

      case 'light blue':
        return Colors.lightBlue;

      case 'light green':
        return Colors.lightGreen;

      case 'dark blue':
        return Colors.blue.shade900;

      case 'dark green':
        return Colors.green.shade900;

      case 'dark red':
        return Colors.red.shade900;

      default:
        return Colors.grey;
    }
  }
}
