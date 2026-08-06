import 'package:e_commerce/features/order/presenation/view/widgets/order_view_body.dart';
import 'package:flutter/material.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});
  static const String routeName = '/order';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const OrderViewBody());
  }
}
