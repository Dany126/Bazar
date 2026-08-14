// lib/features/order/presenation/view/order_success_view.dart
import 'package:e_commerce/features/order/presenation/view/order_view.dart';
import 'package:flutter/material.dart';

const kSuccessAccentColor = Color(0xFF7B61FF);

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key, this.userId});

  final String? userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              color: kSuccessAccentColor,
              child: const Center(
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 96,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Order Placed\nSuccessfully',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'You will receive an email confirmation',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) =>
                                OrderView(userId: userId ?? 'YOUR_USER_ID'),
                          ),
                          (route) => route.isFirst,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSuccessAccentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: const Text('See Order details'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
