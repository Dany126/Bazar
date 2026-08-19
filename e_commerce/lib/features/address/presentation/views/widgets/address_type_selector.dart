import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'address_type_button.dart';

class AddressTypeSelector extends StatelessWidget {
  const AddressTypeSelector({super.key, required this.form});

  final FormGroup form;

  void _selectType(AbstractControl<String> control, String type) {
    control.value = type;

    const fieldsByType = {
      'Apartment': ['buildingName', 'apartmentNumber'],
      'House': ['houseNumber'],
      'Office': ['officeName'],
    };
    final requiredFields = fieldsByType[type] ?? const <String>[];

    for (final fieldName in fieldsByType.values.expand((fields) => fields)) {
      final field = form.control(fieldName);
      if (requiredFields.contains(fieldName)) {
        field.setValidators([Validators.required]);
      } else {
        field.clearValidators();
      }
      field.updateValueAndValidity();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveValueListenableBuilder<String>(
      formControlName: 'addressType',
      builder: (context, control, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              AddressTypeButton(
                title: 'Apartment',
                icon: Icons.apartment_outlined,
                selected: control.value == 'Apartment',
                onTap: () => _selectType(control, 'Apartment'),
              ),
              const SizedBox(width: 10),
              AddressTypeButton(
                title: 'House',
                icon: Icons.home_outlined,
                selected: control.value == 'House',
                onTap: () => _selectType(control, 'House'),
              ),
              const SizedBox(width: 10),
              AddressTypeButton(
                title: 'Office',
                icon: Icons.business_center_outlined,
                selected: control.value == 'Office',
                onTap: () => _selectType(control, 'Office'),
              ),
            ],
          ),
        );
      },
    );
  }
}
