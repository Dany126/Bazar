import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onTap, required this.text});
  final VoidCallback? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,

        decoration: ShapeDecoration(
          color: onTap == null
              ? AppColors.kPrimaryColor.withValues(alpha: 0.5)
              : AppColors.kPrimaryColor /* Primary-100 */,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),

          child: Text(
            textAlign: TextAlign.center,
            text,
            style: AppStyles.textStylesRegular16(
              context,
            ).copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
