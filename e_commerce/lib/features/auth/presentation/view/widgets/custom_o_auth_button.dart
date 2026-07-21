import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomOAuthButton extends StatelessWidget {
  const CustomOAuthButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.imageUrl,
  });

  final VoidCallback onTap;
  final String text;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: ShapeDecoration(
          color: AppColors.kSecondaryAccentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 12),
              child: Image.asset(imageUrl),
            ),
            const Spacer(),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppStyles.textStylesRegular16(
                context,
              ).copyWith(color: AppColors.kSecondaryTextColor),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
