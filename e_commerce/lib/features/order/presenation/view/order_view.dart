import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/order_view_body.dart';
import 'package:flutter/material.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});
  static const String routeName = '/order';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(child: const OrderViewBody()),
    );
  }
}
