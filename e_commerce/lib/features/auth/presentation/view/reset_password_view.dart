import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/widgets/custom_app_bar.dart';
import 'package:e_commerce/features/auth/presentation/view/widgets/reset_password_view_body.dart';
import 'package:e_commerce/features/auth/presentation/view_model/reset_password/reset_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});
  static const routeName = 'ResetPassword';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: BlocProvider<ResetPasswordCubit>(
        create: (context) => getIt<ResetPasswordCubit>(),
        child: SafeArea(child: const ResetPasswordViewBody()),
      ),
    );
  }
}
