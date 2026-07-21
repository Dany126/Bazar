import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hint,
    required this.suffix,
    required this.boardtype,
    required this.obscureText,
    this.validator,
    this.controller,

    this.inputFormatters,
    this.onSaved,
    this.maxLines = 1,
  });

  final String hint;
  final Widget? suffix;
  final TextInputType boardtype;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  final List<TextInputFormatter>? inputFormatters;
  final void Function(String?)? onSaved;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      onSaved: onSaved,
      controller: controller,

      inputFormatters: inputFormatters,
      keyboardType: boardtype,
      obscureText: obscureText,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: AppStyles.textStylesRegular14(context),
      decoration: InputDecoration(
        fillColor: const Color.fromARGB(255, 244, 244, 244),
        filled: true,
        hintText: hint,
        hintStyle: AppStyles.textStylesRegular14(
          context,
        ).copyWith(color: AppColors.kSecondaryTextColor),
        suffixIcon: suffix,
        suffixIconConstraints: const BoxConstraints(
          maxHeight: 40,
          maxWidth: 40,
        ),
        border: _outlineBorder(),
        enabledBorder: _outlineBorder(),
        focusedBorder: _outlineBorder(),
        errorBorder: _outlineBorder(color: Colors.red),
        focusedErrorBorder: _outlineBorder(color: Colors.red),
      ),
    );
  }

  OutlineInputBorder _outlineBorder({Color color = const Color(0xFFE6E9E9)}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide.none,
    );
  }
}
