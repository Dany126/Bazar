// lib/features/checkout/presenation/view/checkout_view.dart
import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_cubit.dart';
import 'package:e_commerce/features/checkout/presentation/views/widgets/checkout_view_body.dart';
import 'package:e_commerce/features/order/presenation/modelview/cubit/order_cubit.dart';
import 'package:e_commerce/features/payment_method/presentation/model_view/cubit/payment_method_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  static const String routeName = '/checkout';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddressCubit>(
          create: (context) => getIt<AddressCubit>()..getAddresses(),
        ),
        BlocProvider<PaymentMethodCubit>(
          create: (context) => getIt<PaymentMethodCubit>()..getPaymentMethods(),
        ),
        BlocProvider<OrderCubit>(create: (context) => getIt<OrderCubit>()),
      ],
      child: const Scaffold(body: SafeArea(child: CheckoutViewBody())),
    );
  }
}
