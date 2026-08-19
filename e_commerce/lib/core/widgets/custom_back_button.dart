import 'package:e_commerce/core/utils/assets.dart';
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Transform.rotate(
              angle: 3.1415926535,
              child: Image.asset(
                Assets.assetsImagesArrowright,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
