import 'package:e_commerce/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.hint,
    this.validator,
    this.controller,
    required this.onSaved,
  });

  final String hint;
  final String? Function(String?)? validator; // ✅ passthrough
  final TextEditingController? controller;
  final void Function(String?)? onSaved;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      onSaved: widget.onSaved,

      hint: widget.hint,
      controller: widget.controller,
      validator: widget.validator, // ✅ wired up
      suffix: GestureDetector(
        onTap: () => setState(() => _isObscure = !_isObscure),
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: _isObscure
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_off),
        ),
      ),
      boardtype: TextInputType.visiblePassword,
      obscureText: _isObscure,
    );
  }
}
