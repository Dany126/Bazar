import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

// ignore: strict_top_level_inference
AppBar customAppBar(context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    leadingWidth: 100,

    // leadingWidth: MediaQuery.of(context).size.width * .5,
    leading: Row(
      children: [
        const SizedBox(width: 20),
        Container(
          width: 50,
          height: 50,
          decoration: ShapeDecoration(
            color: AppColors.kSecondaryAccentColor /* Bg-Light-2 */,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1000),
            ),
          ),
          child: Center(
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                size: 20,
                Icons.arrow_back_ios_new,
                color: Color(0xff272727),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
