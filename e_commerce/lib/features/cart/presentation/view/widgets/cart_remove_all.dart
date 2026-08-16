import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartRemoveAll extends StatelessWidget {
  const CartRemoveAll({super.key, this.horizontalPadding = 0});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding > 16 ? 4 : 0),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {
            context.read<CartCubit>().removeAllFromCartUseCase();
          },
          child: Text(
            'Remove All',
            style: AppStyles.textStylesSemiBold15(
              context,
            ).copyWith(color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
