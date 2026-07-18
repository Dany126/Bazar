import 'package:e_commerce/features/auth/presentation/view/widgets/auth_view_body.dart';
import 'package:flutter/material.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});
  static const routeName = 'AuthView';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: AuthViewBody());
  }
}
