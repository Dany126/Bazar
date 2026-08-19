import 'package:e_commerce/core/widgets/custom_app_bar.dart';
import 'package:e_commerce/features/auth/presentation/view/widgets/reset_password_view_body.dart';
import 'package:flutter/material.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});
  static const routeName = 'ResetPassword';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(child: const ResetPasswordViewBody()),
    );
  }
}
