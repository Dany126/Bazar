import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'address_text_field.dart';
import 'apartment_and_floor_fields.dart';

class AddressTypeDependentFields extends StatelessWidget {
  const AddressTypeDependentFields({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveValueListenableBuilder<String>(
      formControlName: 'addressType',
      builder: (context, control, child) {
        final type = control.value;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Column(
            key: ValueKey(type),
            children: switch (type) {
              'House' => const [
                AddressTextField(
                  formControlName: 'houseNumber',
                  hintText: 'House number',
                  keyboardType: TextInputType.number,
                ),
              ],
              'Office' => const [
                AddressTextField(
                  formControlName: 'officeName',
                  hintText: 'Office name',
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AddressTextField(
                        formControlName: 'officeNumber',
                        hintText: 'Office number',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: AddressTextField(
                        formControlName: 'floor',
                        hintText: 'floor (optional)',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
              _ => const [
                AddressTextField(
                  formControlName: 'buildingName',
                  hintText: 'Building name',
                ),
                SizedBox(height: 12),
                ApartmentAndFloorFields(),
              ],
            },
          ),
        );
      },
    );
  }
}
