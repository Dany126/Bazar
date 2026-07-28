import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/home/presentation/viewModel/cubit/home_cubit/home_cubit.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/home_view_bloc_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const routeName = 'home';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()..fetchHomeData(),
      child: const HomeViewBlocConsumer(),
    );
  }
}
