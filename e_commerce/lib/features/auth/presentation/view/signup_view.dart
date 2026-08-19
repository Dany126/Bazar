import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/widgets/custom_app_bar.dart';
import 'package:e_commerce/features/auth/presentation/view/widgets/signup_view_body.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_up_cubit/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});
  static const routeName = 'SignUpView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),

      body: SafeArea(
        child: BlocProvider<SignUpCubit>(
          create: (context) => getIt<SignUpCubit>(),
          child: const SignUpViewBody(),
        ),
      ),
    );
  }
}
