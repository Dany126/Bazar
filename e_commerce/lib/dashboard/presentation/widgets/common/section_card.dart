import 'package:flutter/material.dart';

/// Rounded card container used for chart panels, tables, and lists.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    required this.background,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final Color background;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}
