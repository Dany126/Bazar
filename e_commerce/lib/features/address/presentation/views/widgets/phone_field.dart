import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Container(
            width: 32,
            height: 22,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Expanded(child: Container(color: Colors.red)),
                Expanded(child: Container(color: Colors.white)),
                Expanded(child: Container(color: Colors.black)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade600),
          const SizedBox(width: 14),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          const SizedBox(width: 16),
          Expanded(
            child: ReactiveTextField<String>(
              formControlName: 'phone',
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Phone number',
                labelStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              validationMessages: {
                ValidationMessage.required: (_) => 'Phone number is required',
              },
            ),
          ),
        ],
      ),
    );
  }
}
