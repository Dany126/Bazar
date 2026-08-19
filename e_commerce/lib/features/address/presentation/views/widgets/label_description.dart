import 'package:flutter/material.dart';

class LabelDescription extends StatelessWidget {
  const LabelDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Text(
        'Give this address a label so you can easily choose '
        'between them (e.g. Parent\'s home)',
        style: TextStyle(
          fontSize: 13,
          height: 1.35,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
