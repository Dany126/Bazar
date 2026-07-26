import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static double getFontSize(double size, BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 360) {
      return size * 0.8;
    } else if (width < 600) {
      return size * 1;
    } else {
      return size * 1.3;
    }
  }

  static TextStyle textStylesBold32(BuildContext context) => TextStyle(
    fontFamily: 'Gabarito',
    fontSize: getFontSize(32, context),
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.3,
    color: AppColors.kTextColor,
  );

  static TextStyle textStylesSemiBold24(BuildContext context) => TextStyle(
    fontFamily: 'Gabarito',
    fontSize: getFontSize(24, context),
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: AppColors.kTextColor,
  );

  static TextStyle textStylesSemiBold20(BuildContext context) => TextStyle(
    fontFamily: 'Gabarito',
    fontSize: getFontSize(20, context),
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.kTextColor,
  );

  static TextStyle textStylesSemiBold18(BuildContext context) => TextStyle(
    fontFamily: 'Gabarito',
    fontSize: getFontSize(18, context),
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.kTextColor,
  );

  static TextStyle textStylesBold22Mono(BuildContext context) => TextStyle(
    fontFamily: 'Gabarito',
    fontSize: getFontSize(22, context),
    fontWeight: FontWeight.w700,
    color: AppColors.kPrimaryAccentColorDark,
  );

  static TextStyle textStylesBold13Mono(BuildContext context) => TextStyle(
    fontFamily: 'Gabarito',
    fontSize: getFontSize(13, context),
    fontWeight: FontWeight.w700,
    color: AppColors.kPrimaryAccentColorDark,
  );

  static TextStyle textStylesSemiBold15(BuildContext context) => TextStyle(
    fontFamily: 'Gabarito',
    fontSize: getFontSize(15, context),
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.kMainBackgroundColor,
  );

  static TextStyle textStylesSemiBold14(BuildContext context) => TextStyle(
    fontFamily: 'Gabarito',
    fontSize: getFontSize(14, context),
    fontWeight: FontWeight.w600,
    color: AppColors.kTextColor,
  );

  static TextStyle textStylesRegular14(BuildContext context) => TextStyle(
    fontFamily: 'Gabarito',
    fontSize: getFontSize(14, context),
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.kTextColor,
  );

  static TextStyle textStylesRegular12(BuildContext context) => TextStyle(
    fontFamily: 'Gabarito',
    fontSize: getFontSize(12, context),
    fontWeight: FontWeight.w400,
    color: AppColors.kSecondaryTextColor,
  );

  static TextStyle textStylesRegular16(BuildContext context) => TextStyle(
    fontFamily: 'Gabarito',
    fontSize: getFontSize(16, context),
    fontWeight: FontWeight.w400,
  );

  static TextStyle textStylesMedium11(BuildContext context) => TextStyle(
    fontFamily: 'Gabarito',
    fontSize: getFontSize(11, context),
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    color: AppColors.kSecondaryTextColor,
  );

  static TextStyle textStylesBold12Mono(BuildContext context) => TextStyle(
    fontFamily: 'Gabarito',
    fontSize: getFontSize(12, context),
    fontWeight: FontWeight.w700,
    color: AppColors.kTextColor,
  );

  static TextStyle textStylesRegular11Mono(BuildContext context) => TextStyle(
    fontFamily: 'Gabarito',
    fontSize: getFontSize(11, context),
    fontWeight: FontWeight.w400,
    color: AppColors.kSecondaryTextColor,
  );
}
