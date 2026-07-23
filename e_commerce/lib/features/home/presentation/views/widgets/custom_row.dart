import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  const CustomRow({
    super.key,
    required this.title,
    this.withColor,
    required this.onTap,
  });
  final String title;
  final bool? withColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Text(
          title,
          style: withColor == true
              ? AppStyles.textStylesSemiBold18(
                  context,
                ).copyWith(color: AppColors.kPrimaryColor)
              : AppStyles.textStylesSemiBold18(context),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          child: Text('See All', style: AppStyles.textStylesRegular16(context)),
        ),
      ],
    );
  }
}
