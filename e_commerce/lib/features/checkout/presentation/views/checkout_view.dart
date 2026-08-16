import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/cart/domain/entity/cart_entity.dart';
import 'package:e_commerce/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:e_commerce/features/checkout/presentation/views/widgets/checkout_view_body.dart';
import 'package:e_commerce/features/order/presenation/modelview/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutView extends StatelessWidget {
  static const String routeName = '/checkout-view';

  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final CartEntity cart =
        ModalRoute.of(context)!.settings.arguments as CartEntity;
    return MultiBlocProvider(
      providers: [
        BlocProvider<CheckoutCubit>(
          create: (_) => getIt<CheckoutCubit>()..init(),
        ),
        BlocProvider<OrderCubit>(create: (_) => getIt<OrderCubit>()),
      ],
      child: Scaffold(
        body: SafeArea(child: CheckoutViewBody(cart: cart)),
      ),
    );
  }
}
