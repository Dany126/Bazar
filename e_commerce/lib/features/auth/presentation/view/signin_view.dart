import 'package:e_commerce/features/auth/presentation/view/widgets/signin_view_body.dart';
import 'package:flutter/material.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});
  static const routeName = 'SignInView';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SignInViewBody());
  }
}
