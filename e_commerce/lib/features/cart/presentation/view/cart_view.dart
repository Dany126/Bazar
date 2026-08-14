// lib/features/cart/presenation/view/cart_view.dart
import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:e_commerce/features/cart/presentation/view/widgets/cart_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartCubit>(
      create: (context) => getIt<CartCubit>()..getCart(),
      child: const Scaffold(body: SafeArea(child: CartViewBody())),
    );
  }
}
