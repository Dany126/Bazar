import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, Failure failure) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        failure.message,
        style: AppStyles.textStylesRegular14(
          context,
        ).copyWith(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      elevation: 0,
    ),
  );
}
