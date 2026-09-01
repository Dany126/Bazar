import 'package:e_commerce/core/helper_function/shared_prefs_helper.dart';
import 'package:e_commerce/core/helper_function/snack_bar.dart';
import 'package:e_commerce/core/utils/app_space.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/widgets/custom_button.dart';
import 'package:e_commerce/core/widgets/custom_text_form_field.dart';
import 'package:e_commerce/core/widgets/text_form_faild_validators.dart';
import 'package:e_commerce/features/auth/presentation/view/widgets/password_field.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_up_cubit/sign_up_cubit.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_up_cubit/sign_up_state.dart';
import 'package:e_commerce/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  String name = '';
  String phone = '';
  String email = '';
  String password = '';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) async {
        if (state is FailureState) {
          if (!context.mounted) return;

          showSnackBar(context, state.failure);
        }

        if (state is SuccessState) {
          final user = state.user;

          // Save login state.
          await SharedPrefsHelper.setLoggedIn(true);

          // Save role returned from backend.
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
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: AppSpacing.md),

                      // =========================
                      // TITLE
                      // =========================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Create an account',
                            style: AppStyles.textStylesBold32(context),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // =========================
                      // NAME
                      // =========================
                      CustomTextFormField(
                        hint: 'Enter your name',
                        suffix: null,
                        boardtype: TextInputType.name,
                        obscureText: false,
                        validator: AppValidators.required('Name'),
                        onSaved: (value) {
                          name = value ?? '';
                        },
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // =========================
                      // PHONE
                      // =========================
                      CustomTextFormField(
                        hint: 'Enter your phone number',
                        suffix: null,
                        boardtype: TextInputType.phone,
                        obscureText: false,
                        validator: AppValidators.phone,
                        onSaved: (value) {
                          phone = value ?? '';
                        },
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // =========================
                      // EMAIL
                      // =========================
                      CustomTextFormField(
                        hint: 'Enter your email',
                        suffix: null,
                        boardtype: TextInputType.emailAddress,
                        obscureText: false,
                        validator: AppValidators.email,
                        onSaved: (value) {
                          email = value ?? '';
                        },
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // =========================
                      // PASSWORD
                      // =========================
                      PasswordField(
                        hint: 'Enter your password',
                        validator: AppValidators.password,
                        onSaved: (value) {
                          password = value ?? '';
                        },
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // =========================
                      // SIGN UP
                      // =========================
                      BlocBuilder<SignUpCubit, SignUpState>(
                        builder: (context, state) {
                          final isLoading = state is LoadingState;

                          return CustomButton(
                            onTap: () async {
                              if (isLoading) return;

                              if (!formKey.currentState!.validate()) {
                                return;
                              }

                              formKey.currentState!.save();

                              await context.read<SignUpCubit>().signUp(
                                name: name,
                                phone: phone,
                                email: email,
                                password: password,
                              );
                            },
                            text: isLoading ? 'Creating account...' : 'Sign up',
                          );
                        },
                      ),

                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
