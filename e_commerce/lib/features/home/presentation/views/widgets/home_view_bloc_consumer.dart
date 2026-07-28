import 'dart:developer';

import 'package:e_commerce/features/home/presentation/viewModel/cubit/home_cubit/home_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/cubit/home_cubit/home_states.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/home_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewBlocConsumer extends StatelessWidget {
  const HomeViewBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is HomeLoaded) {
          return HomeViewBody();
        }

        return Scaffold(body: Center(child: Text(state.toString())));
      },
      listener: (context, state) {
        if (state is HomeError) {
          log(state.message);
        }
      },
    );
  }
}
