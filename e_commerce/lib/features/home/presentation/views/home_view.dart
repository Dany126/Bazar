import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/auth/presentation/view_model/sign_out/cubit/sign_out_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/cubit/get_category_products_cubit/get_category_products_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/cubit/home_cubit/home_cubit.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/home_view_bloc_consumer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const routeName = 'HomeView';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 100,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            activeIcon: Image.asset(Assets.assetsImagesActiveHome),
            icon: Image.asset(Assets.assetsImagesInActiveHome),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(Assets.assetsImagesActiveReceipt),
            icon: Image.asset(Assets.assetsImagesInActiveReceipt),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(Assets.assetsImagesActivenotificationbing),
            icon: Image.asset(Assets.assetsImagesInActivenotificationbing),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(Assets.assetsImagesActiveprofile),
            icon: Image.asset(Assets.assetsImagesInActiveprofile),
            label: '',
          ),
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<HomeCubit>()),
          BlocProvider(create: (context) => getIt<CategoryProductsCubit>()),
        ],
        child: HomeViewBlocConsumer(),
      ),
    );
  }
}
