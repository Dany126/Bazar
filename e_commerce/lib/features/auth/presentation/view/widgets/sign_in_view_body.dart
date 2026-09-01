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
import 'package:e_commerce/features/auth/presentation/view_model/sign_in_cubit/sign_in_state.dart';
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
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) async {
        if (state is SignInLoading) {
          // Loading is handled by the button below.
        }

        if (state is SignInError) {
          if (!context.mounted) return;

          showSnackBar(context, state.failure);
        }

        if (state is SignInSuccess) {
          final user = state.user;

          // Save login state.
          await SharedPrefsHelper.setLoggedIn(true);

          // IMPORTANT:
          // Save the role returned from the backend.
          await SharedPrefsHelper.setUserRole(user.role);

          if (!context.mounted) return;

          // ADMIN -> Dashboard
          // USER  -> MainView
          final targetRoute = user.isAdmin
              ? 'admin_dashboard'
              : MainView.routeName;

          Navigator.pushNamedAndRemoveUntil(
            context,
            targetRoute,
            (route) => false,
          );
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 600;
          final isDesktop = constraints.maxWidth >= 1000;

          final horizontalPadding = isDesktop
              ? 80.0
              : isTablet
              ? 48.0
              : 23.0;

          final maxWidth = isDesktop ? 500.0 : double.infinity;

          return Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(height: AppSpacing.xl * 2),

                    // =========================
                    // TITLE
                    // =========================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Sign in',
                          style: AppStyles.textStylesBold32(context),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSpacing.xl * 2),

                    // =========================
                    // FORM
                    // =========================
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

                    // =========================
                    // FORGOT PASSWORD
                    // =========================
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: [
                            SizedBox(width: AppSpacing.xs * 2),

                            Text(
                              'Forgot Password ? ',
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
                                'Reset',
                                style: AppStyles.textStylesSemiBold14(context)
                                    .copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: AppSpacing.md * 2),

                    // =========================
                    // SIGN IN BUTTON
                    // =========================
                    BlocBuilder<SignInCubit, SignInState>(
                      builder: (context, state) {
                        final isLoading = state is SignInLoading;

                        return CustomButton(
                          onTap: () {
                            if (isLoading) return;

                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();

                              context.read<SignInCubit>().signIn(
                                email: email,
                                password: password,
                              );
                            }
                          },
                          text: isLoading ? 'Signing in...' : 'Sign in',
                        );
                      },
                    ),

                    SizedBox(height: AppSpacing.md),

                    // =========================
                    // CREATE ACCOUNT
                    // =========================
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
                              Navigator.pushNamed(
                                context,
                                SignUpView.routeName,
                              );
                            },
                            child: Text(
                              'Create an account',
                              style: AppStyles.textStylesSemiBold14(
                                context,
                              ).copyWith(decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSpacing.xl * 3),

                    // =========================
                    // OAUTH
                    // =========================
                    const CustomOAuthForm(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
