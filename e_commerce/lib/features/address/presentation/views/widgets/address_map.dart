import 'package:e_commerce/features/address/presentation/views/map_view.dart';
import 'package:flutter/material.dart';

class AddressMap extends StatelessWidget {
  const AddressMap({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MapView()),
      ),
      child: Container(
        height: 210,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.map_outlined, size: 50, color: Colors.grey.shade500),
            const Icon(Icons.location_pin, size: 55, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
