// lib/features/product_details/presenation/view/widgets/color_picker_sheet.dart
import 'package:flutter/material.dart';
import 'product_details_view_body.dart' show kProductAccentColor;

class ColorPickerSheet extends StatelessWidget {
  const ColorPickerSheet({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onSelected,
  });

  final List<String> colors;
  final String? selectedColor;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Color',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...colors.map((color) {
              final isSelected = color == selectedColor;
              return InkWell(
                onTap: () {
                  onSelected(color);
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? kProductAccentColor : Colors.grey[100],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _colorName(color),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _colorFromHex(color),
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 10),
                        const Icon(Icons.check, color: Colors.white, size: 18),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _colorFromHex(String hex) {
    final cleanHex = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleanHex', radix: 16));
  }

  // Display name fallback — your backend should ideally send a name
  // alongside the hex; swap this out once it does.
  String _colorName(String hex) => hex.toUpperCase();
}
