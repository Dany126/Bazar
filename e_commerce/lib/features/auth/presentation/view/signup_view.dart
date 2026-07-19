import 'package:e_commerce/features/auth/presentation/view/widgets/custom_app_bar.dart';
import 'package:e_commerce/features/auth/presentation/view/widgets/signup_view_body.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});
  static const routeName = 'SignUpView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),

      body: const SafeArea(child: SignUpViewBody()),
    );
  }
}
