import 'package:e_commerce/features/splash/presentation/view/widgets/splash_view_body.dart';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  static const routeName = 'SplashView';

  @override

  Widget build(BuildContext context) {
    return const Scaffold(body: SplashViewBody());
  }
}
