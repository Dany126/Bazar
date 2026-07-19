import 'package:e_commerce/core/utils/app_space.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/core/widgets/custom_button.dart';
import 'package:e_commerce/core/widgets/custom_text_form_field.dart';
import 'package:e_commerce/core/widgets/text_form_faild_validators.dart';
import 'package:e_commerce/features/auth/presentation/view/sign_in_view.dart';
import 'package:flutter/material.dart';

class ResetPasswordViewBody extends StatelessWidget {
  const ResetPasswordViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("Forgot Password", style: AppStyles.textStylesBold32),
              ],
            ),
            SizedBox(height: AppSpacing.xl),
            const CustomTextFormField(
              hint: 'Enter your email',
              suffix: null,
              boardtype: TextInputType.emailAddress,
              obscureText: false,
              validator: AppValidators.email,
            ),
            SizedBox(height: AppSpacing.xl),
            CustomButton(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Dialog.fullscreen(
                      backgroundColor: Colors.white,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(Assets.assetsImagesMessage),
                              const SizedBox(height: AppSpacing.md),
                              const Text(
                                'Check your email',
                                style: AppStyles.textStylesBold32,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              const Text(
                                'We have sent a password recovery link to your email.',
                                textAlign: TextAlign.center,
                                style: AppStyles.textStylesRegular16,
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              CustomButton(
                                onTap: () {
                                  Navigator.of(
                                    context,
                                  ).pushReplacementNamed(SignInView.routeName);
                                },
                                text: 'Return to Login',
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              text: 'Reset Password',
            ),
          ],
        ),
      ),
    );
  }
}
