import 'package:e_commerce/core/helper_function/shared_prefs_helper.dart';
import 'package:e_commerce/core/utils/app_space.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/widgets/custom_button.dart';
import 'package:e_commerce/core/widgets/custom_text_form_field.dart';
import 'package:e_commerce/core/widgets/text_form_faild_validators.dart';
import 'package:e_commerce/features/auth/presentation/view/widgets/password_field.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_up_cubit/sign_up_cubit.dart';

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
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: Form(
          key: formKey,
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

              PasswordField(
                hint: 'Enter your password',
                validator: AppValidators.password,
                onSaved: (value) {
                  password = value ?? '';
                },
              ),

              const SizedBox(height: AppSpacing.xl),

              CustomButton(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();

                    await context.read<SignUpCubit>().signUp(
                      name: name,
                      phone: phone,
                      email: email,
                      password: password,
                    );

                    if (mounted) {
                      await SharedPrefsHelper.setLoggedIn(true);
                      Navigator.pushReplacementNamed(
                        // ignore: use_build_context_synchronously
                        context,
                        MainView.routeName,
                      );
                    }
                  }
                },

                text: 'Sign up',
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
