import 'package:e_commerce/features/onboarding/presentation/view/widgets/onboarding_view_body.dart';
import 'package:flutter/material.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});
  static const routeName = 'OnboardingView';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: OnboardingViewBody());
  }
}
