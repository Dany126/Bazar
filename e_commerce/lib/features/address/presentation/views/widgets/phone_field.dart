import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PhoneField extends StatefulWidget {
  const PhoneField({super.key, required this.form});

  final FormGroup form;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneCountry {
  const _PhoneCountry({
    required this.name,
    required this.code,
    required this.flag,
  });

  final String name;
  final String code;
  final String flag;
}

class _PhoneFieldState extends State<PhoneField> {
  static const countries = [
    _PhoneCountry(name: 'Egypt', code: '+20', flag: '🇪🇬'),
    _PhoneCountry(name: 'Saudi Arabia', code: '+966', flag: '🇸🇦'),
    _PhoneCountry(name: 'United Arab Emirates', code: '+971', flag: '🇦🇪'),
    _PhoneCountry(name: 'United States', code: '+1', flag: '🇺🇸'),
    _PhoneCountry(name: 'United Kingdom', code: '+44', flag: '🇬🇧'),
    _PhoneCountry(name: 'Germany', code: '+49', flag: '🇩🇪'),
  ];

  _PhoneCountry _selectedCountry = countries.first;

  Future<void> _selectCountry() async {
    final selected = await showModalBottomSheet<_PhoneCountry>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: countries.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final country = countries[index];
            return ListTile(
              leading: Text(country.flag, style: const TextStyle(fontSize: 26)),
              title: Text(country.name),
              trailing: Text(
                country.code,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              onTap: () => Navigator.of(context).pop(country),
            );
          },
        ),
      ),
    );

    if (selected == null || !mounted) return;

    final control = widget.form.control('phone');
    final currentValue = control.value?.toString() ?? '';
    final previousCode = _selectedCountry.code;
    final localNumber = currentValue.startsWith(previousCode)
        ? currentValue.substring(previousCode.length).trim()
        : currentValue;

    control.value = '${selected.code} $localNumber'.trim();
    setState(() => _selectedCountry = selected);
  }

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
          InkWell(
            onTap: _selectCountry,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedCountry.flag,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _selectedCountry.code,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 2),
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
