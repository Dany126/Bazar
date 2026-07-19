import 'package:e_commerce/core/utils/app_space.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/auth/presentation/view/widgets/custom_o_auth_button.dart';
import 'package:flutter/material.dart';

class CustomOAuthForm extends StatelessWidget {
  const CustomOAuthForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: Theme.of(context).platform == TargetPlatform.iOS,
          replacement: const SizedBox(),
          child: CustomOAuthButton(
            onTap: () {},
            text: 'Sign in with Apple',
            imageUrl: Assets.assetsImagesApple,
          ),
        ),
        CustomOAuthButton(
          onTap: () {},
          text: 'Sign in with Google',
          imageUrl: Assets.assetsImagesGoogle,
        ),
        SizedBox(height: AppSpacing.md),
        CustomOAuthButton(
          onTap: () {},
          text: 'Sign in with Facebook',
          imageUrl: Assets.assetsImagesFacebook,
        ),
        SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
