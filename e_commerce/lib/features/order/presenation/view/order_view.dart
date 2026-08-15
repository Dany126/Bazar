import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/features/order/presenation/modelview/cubit/order_cubit.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/order_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  static const String routeName = '/order';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderCubit>(
      create: (context) =>
          getIt<OrderCubit>()..getMyOrders(filter: OrderStatus.all),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Orders',
            style: AppStyles.textStylesBold22Mono(
              context,
            ).copyWith(color: Colors.black),
          ),
        ),
        body: const SafeArea(child: OrderViewBody()),
      ),
    );
  }
}
