import 'package:e_commerce/features/auth/presentation/view/widgets/signup_view_body.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});
  static const routeName = 'SignUpView';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SignUpViewBody());
  }
}
