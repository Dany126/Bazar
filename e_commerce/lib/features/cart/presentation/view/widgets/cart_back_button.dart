import 'package:e_commerce/core/utils/assets.dart';
import 'package:flutter/material.dart';

class CartBackButton extends StatelessWidget {
  const CartBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(10),
        child: Transform.rotate(
          angle: 3.1415926535,
          child: Image.asset(
            Assets.assetsImagesArrowright,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
