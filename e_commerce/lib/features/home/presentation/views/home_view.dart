import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/home/presentation/viewModel/categories_cubit/get_categories_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_cubit.dart';

import 'package:e_commerce/features/home/presentation/views/widgets/home_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const routeName = 'home';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetCategoriesCubit>(
          create: (_) => getIt<GetCategoriesCubit>(),
        ),
        BlocProvider<GetProductsCubit>(
          create: (_) => getIt<GetProductsCubit>(),
        ),
      ],
      child: const HomeViewBody(),
    );
  }
}
