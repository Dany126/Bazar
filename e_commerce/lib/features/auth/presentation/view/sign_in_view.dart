import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/auth/presentation/view/widgets/sign_in_view_body.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_in_cubit/sign_in_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  static const routeName = 'AuthView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<SignInCubit>(
          create: (context) => getIt<SignInCubit>(),

          child: const SignInBody(),
        ),
      ),
    );
  }
}
// Dany123?