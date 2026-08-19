import 'package:flutter/material.dart';

import 'address_text_field.dart';

class ApartmentAndFloorFields extends StatelessWidget {
  const ApartmentAndFloorFields({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: AddressTextField(
            formControlName: 'apartmentNumber',
            hintText: 'Apt. number',
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: AddressTextField(
            formControlName: 'floor',
            hintText: 'Floor (optional)',
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}
