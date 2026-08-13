import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class FilterOptionData {
  final String label;
  final String value;

  const FilterOptionData(this.label, this.value);
}

/// Generic single-select filter sheet (used for Sort by / Gender / Deals).
/// Returns the selected value's `value`, or null if cleared, when popped.
class SingleSelectFilterSheet extends StatefulWidget {
  const SingleSelectFilterSheet({
    super.key,
    required this.title,
    required this.options,
    this.initialValue,
  });

  final String title;
  final List<FilterOptionData> options;
  final String? initialValue;

  @override
  State<SingleSelectFilterSheet> createState() =>
      _SingleSelectFilterSheetState();

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required List<FilterOptionData> options,
    String? initialValue,
  }) {
    return showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SingleSelectFilterSheet(
        title: title,
        options: options,
        initialValue: initialValue,
      ),
    );
  }
}

class _SingleSelectFilterSheetState extends State<SingleSelectFilterSheet> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SheetHeader(
              title: widget.title,
              onClear: () => Navigator.of(context).pop(null),
            ),
            const Divider(height: 1),
            ...widget.options.map((option) {
              final isSelected = option.value == _selected;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: ListTile(
                  title: Text(
                    option.label,
                    style: AppStyles.textStylesRegular16(
                      context,
                    ).copyWith(color: isSelected ? Colors.white : null),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                  tileColor: isSelected
                      ? AppColors.kPrimaryColor
                      : AppColors.kCardBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  onTap: () {
                    setState(() => _selected = option.value);
                    Navigator.of(context).pop(option.value);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Price range filter sheet — two numeric inputs (Min / Max).
class PriceFilterSheet extends StatefulWidget {
  const PriceFilterSheet({super.key, this.initialMin, this.initialMax});

  final double? initialMin;
  final double? initialMax;

  @override
  State<PriceFilterSheet> createState() => _PriceFilterSheetState();

  static Future<({double? min, double? max})?> show(
    BuildContext context, {
    double? initialMin,
    double? initialMax,
  }) {
    return showModalBottomSheet<({double? min, double? max})?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) =>
          PriceFilterSheet(initialMin: initialMin, initialMax: initialMax),
    );
  }
}

class _PriceFilterSheetState extends State<PriceFilterSheet> {
  late final TextEditingController _minController;
  late final TextEditingController _maxController;

  @override
  void initState() {
    super.initState();
    _minController = TextEditingController(
      text: widget.initialMin?.toStringAsFixed(0) ?? '',
    );
    _maxController = TextEditingController(
      text: widget.initialMax?.toStringAsFixed(0) ?? '',
    );
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 16, left: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SheetHeader(
              title: 'Price',
              onClear: () => Navigator.of(context).pop((min: null, max: null)),
            ),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PriceField(controller: _minController, hint: 'Min'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PriceField(controller: _maxController, hint: 'Max'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () {
                  final min = double.tryParse(_minController.text);
                  final max = double.tryParse(_maxController.text);
                  Navigator.of(context).pop((min: min, max: max));
                },
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceField extends StatelessWidget {
  const _PriceField({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.kCardBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.title, required this.onClear});

  final String title;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          TextButton(
            onPressed: onClear,
            child: const Text('Clear', style: TextStyle(color: Colors.black54)),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.textStylesSemiBold18(context),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
