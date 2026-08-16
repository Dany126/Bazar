import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

import 'cart_back_button.dart';

class CartAppBar extends StatelessWidget {
  const CartAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          const CartBackButton(),
          const Spacer(),
          Text('$title', style: AppStyles.textStylesSemiBold20(context)),
          const Spacer(),
          const SizedBox(width: 42),
        ],
      ),
    );
  }
}
