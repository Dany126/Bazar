import 'package:flutter/material.dart';

import 'product_details_view_body.dart' show kProductAccentColor;

class ColorPickerSheet extends StatelessWidget {
  const ColorPickerSheet({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  final List<String> colors;
  final String? selectedColor;
  final ValueChanged<String> onColorSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - SAME as SizePickerSheet
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

            // Colors - SAME row size/style as SizePickerSheet
            ...colors.map((colorName) {
              final isSelected = colorName == selectedColor;

              return InkWell(
                onTap: () {
                  onColorSelected(colorName);
                  Navigator.of(context).pop();
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
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
                      // Color circle
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: _colorFromValue(colorName),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Colors.white.withOpacity(0.8)
                                : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      // Color name
                      Text(
                        colorName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),

                      const Spacer(),

                      // Check
                      if (isSelected)
                        const Icon(Icons.check, color: Colors.white, size: 18),
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

  static Color _colorFromValue(String value) {
    final input = value.trim();

    if (input.isEmpty) {
      return Colors.grey;
    }

    final hexColor = _colorFromHex(input);

    if (hexColor != null) {
      return hexColor;
    }

    switch (input.toLowerCase()) {
      case 'black':
        return Colors.black;

      case 'white':
        return Colors.white;

      case 'red':
        return Colors.red;

      case 'green':
        return Colors.green;

      case 'blue':
        return Colors.blue;

      case 'yellow':
        return Colors.yellow;

      case 'orange':
        return Colors.orange;

      case 'purple':
        return Colors.purple;

      case 'pink':
        return Colors.pink;

      case 'brown':
        return Colors.brown;

      case 'grey':
      case 'gray':
        return Colors.grey;

      case 'cyan':
        return Colors.cyan;

      case 'teal':
        return Colors.teal;

      case 'indigo':
        return Colors.indigo;

      case 'lime':
        return Colors.lime;

      case 'amber':
        return Colors.amber;

      case 'deep orange':
      case 'deeporange':
        return Colors.deepOrange;

      case 'deep purple':
      case 'deeppurple':
        return Colors.deepPurple;

      case 'light blue':
      case 'lightblue':
        return Colors.lightBlue;

      case 'light green':
      case 'lightgreen':
        return Colors.lightGreen;

      case 'light pink':
      case 'lightpink':
        return Colors.pink.shade100;

      case 'dark red':
      case 'darkred':
        return Colors.red.shade900;

      case 'dark blue':
      case 'darkblue':
        return Colors.blue.shade900;

      case 'dark green':
      case 'darkgreen':
        return Colors.green.shade900;

      case 'navy':
        return const Color(0xFF000080);

      case 'maroon':
        return const Color(0xFF800000);

      case 'olive':
        return const Color(0xFF808000);

      case 'silver':
        return const Color(0xFFC0C0C0);

      case 'gold':
        return const Color(0xFFFFD700);

      case 'beige':
        return const Color(0xFFF5F5DC);

      case 'cream':
        return const Color(0xFFFFFDD0);

      case 'transparent':
        return Colors.transparent;

      default:
        return Colors.grey;
    }
  }

  static Color? _colorFromHex(String value) {
    var hex = value.trim();

    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    }

    if (!RegExp(r'^[0-9a-fA-F]+$').hasMatch(hex)) {
      return null;
    }

    if (hex.length == 6) {
      try {
        return Color(int.parse('FF$hex', radix: 16));
      } catch (_) {
        return null;
      }
    }

    if (hex.length == 8) {
      try {
        return Color(int.parse(hex, radix: 16));
      } catch (_) {
        return null;
      }
    }

    return null;
  }
}
