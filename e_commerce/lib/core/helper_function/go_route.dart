import 'package:e_commerce/features/auth/presentation/view/auth_view.dart';
import 'package:e_commerce/features/auth/presentation/view/signin_view.dart';
import 'package:e_commerce/features/auth/presentation/view/signup_view.dart';
import 'package:e_commerce/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:e_commerce/features/splash/presentation/view/splash_view.dart';
import 'package:flutter/material.dart';

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(builder: (context) => const SplashView());

    case OnboardingView.routeName:
      return MaterialPageRoute(builder: (context) => const OnboardingView());

    case AuthView.routeName:
      return MaterialPageRoute(builder: (context) => const AuthView());

    case SignUpView.routeName:
      return MaterialPageRoute(builder: (context) => const SignUpView());

    case SignInView.routeName:
      return MaterialPageRoute(builder: (context) => const SignInView());

    default:
      return MaterialPageRoute(
        builder: (context) =>
            const Scaffold(body: Center(child: Text('Screen does not exist!'))),
      );
  }
}
