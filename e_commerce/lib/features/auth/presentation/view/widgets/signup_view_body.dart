import 'package:e_commerce/core/utils/app_space.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/widgets/custom_button.dart';
import 'package:e_commerce/core/widgets/custom_text_form_field.dart';
import 'package:e_commerce/core/widgets/text_form_faild_validators.dart';
import 'package:e_commerce/features/auth/presentation/view/widgets/password_field.dart';
import 'package:flutter/material.dart';

class SignUpViewBody extends StatelessWidget {
  const SignUpViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: Column(
          children: [
            SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Create an account",
                  style: AppStyles.textStylesBold32(context),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            const CustomTextFormField(
              hint: 'Enter your name',
              suffix: null,
              boardtype: TextInputType.emailAddress,
              obscureText: false,
            ),

            const SizedBox(height: AppSpacing.md),

            const CustomTextFormField(
              hint: 'Enter your phone number',
              suffix: null,
              boardtype: TextInputType.phone,
              validator: AppValidators.phone,
              obscureText: false,
            ),

            const SizedBox(height: AppSpacing.md),

            const CustomTextFormField(
              hint: 'Enter your email',
              suffix: null,
              boardtype: TextInputType.emailAddress,
              obscureText: false,
              validator: AppValidators.email,
            ),

            const SizedBox(height: AppSpacing.md),

            PasswordField(
              hint: 'Enter your password',
              onSaved: (String? value) {},
              validator: AppValidators.password,
            ),

            const SizedBox(height: AppSpacing.xl),

            CustomButton(onTap: () {}, text: 'Sign up'),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
