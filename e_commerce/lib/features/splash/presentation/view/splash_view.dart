import 'package:e_commerce/features/splash/presentation/view/widgets/splash_view_body.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  static const routeName = 'SplashView';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SplashViewBody());
  }

  @override
  initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: 2), () {
    //   Navigator.pushReplacementNamed(context, '/login');
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
