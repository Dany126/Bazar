import 'package:e_commerce/core/helper_function/shared_prefs_helper.dart';
import 'package:e_commerce/core/helper_function/snack_bar.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_space.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/widgets/custom_button.dart';
import 'package:e_commerce/core/widgets/custom_text_form_field.dart';
import 'package:e_commerce/core/widgets/text_form_faild_validators.dart';
import 'package:e_commerce/features/auth/presentation/view/reset_password_view.dart';
import 'package:e_commerce/features/auth/presentation/view/signup_view.dart';
import 'package:e_commerce/features/auth/presentation/view/widgets/custom_o_auth_form.dart';
import 'package:e_commerce/features/auth/presentation/view/widgets/password_field.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_in_cubit/sign_in_cubit.dart';

import 'package:e_commerce/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({super.key});

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  String email = '';
  String password = '';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: AppSpacing.xl * 2),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Sign in", style: AppStyles.textStylesBold32(context)),
              ],
            ),

            SizedBox(height: AppSpacing.xl * 2),

            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: emailController,
                    hint: 'Enter your email address',
                    suffix: null,
                    boardtype: TextInputType.emailAddress,
                    obscureText: false,
                    validator: AppValidators.email,
                    onSaved: (value) {
                      email = value ?? '';
                    },
                  ),

                  SizedBox(height: AppSpacing.md),

                  PasswordField(
                    hint: 'Enter your password',
                    onSaved: (value) {
                      password = value ?? '';
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.xs),

            Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  children: [
                    SizedBox(width: AppSpacing.xs * 2),

                    Text(
                      "Forgot Password ? ",
                      style: AppStyles.textStylesRegular14(
                        context,
                      ).copyWith(color: AppColors.kSecondaryTextColor),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ResetPasswordView.routeName,
                        );
                      },
                      child: Text(
                        "Reset",
                        style: AppStyles.textStylesSemiBold14(
                          context,
                        ).copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppSpacing.md * 2),

            CustomButton(
              onTap: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();

                  var result = await context.read<SignInCubit>().signIn(
                    email: email,
                    password: password,
                  );

                  result.fold(
                    (failure) {
                      showSnackBar(context, failure);
                    },
                    (user) async {
                      await SharedPrefsHelper.setLoggedIn(true);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        MainView.routeName,
                        (route) => false,
                      );
                    },
                  );
                }
              },
              text: 'Sign in',
            ),

            SizedBox(height: AppSpacing.md),

            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  SizedBox(width: AppSpacing.xs * 2),

                  Text(
                    "Don't have an account ? ",
                    style: AppStyles.textStylesRegular14(
                      context,
                    ).copyWith(color: AppColors.kSecondaryTextColor),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignUpView.routeName);
                    },
                    child: Text(
                      "Create an account",
                      style: AppStyles.textStylesSemiBold14(
                        context,
                      ).copyWith(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.xl * 3),

            const CustomOAuthForm(),
          ],
        ),
      ),
    );
  }
}
