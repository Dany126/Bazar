import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_store_settings.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_store_settings_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_store_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSettingsView extends StatefulWidget {
  const AdminSettingsView({super.key});

  @override
  State<AdminSettingsView> createState() => _AdminSettingsViewState();
}

class _AdminSettingsViewState extends State<AdminSettingsView> {
  final _formKey = GlobalKey<FormState>();

  // Store information
  final _storeNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _postalCodeController = TextEditingController();

  // Commerce
  final _taxRateController = TextEditingController();
  final _shippingFeeController = TextEditingController();
  final _freeShippingThresholdController = TextEditingController();
  final _minimumOrderAmountController = TextEditingController();

  // Inventory
  final _lowStockThresholdController = TextEditingController();

  String _currency = 'EGP';

  bool _storeEnabled = true;
  bool _acceptOrders = true;

  bool _formInitialized = false;

  static const List<String> _currencies = [
    'EGP',
    'USD',
    'EUR',
    'SAR',
    'AED',
  ];

  @override
  void dispose() {
    _storeNameController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();

    _taxRateController.dispose();
    _shippingFeeController.dispose();
    _freeShippingThresholdController.dispose();
    _minimumOrderAmountController.dispose();

    _lowStockThresholdController.dispose();

    super.dispose();
  }

  void _fillForm(AdminStoreSettings settings) {
    if (_formInitialized) return;

    _formInitialized = true;

    _storeNameController.text = settings.storeName;
    _descriptionController.text = settings.description;
    _emailController.text = settings.email;
    _phoneController.text = settings.phone;
    _addressController.text = settings.address;
    _cityController.text = settings.city;
    _countryController.text = settings.country;
    _postalCodeController.text = settings.postalCode;

    _taxRateController.text = _formatNumber(settings.taxRate);
    _shippingFeeController.text = _formatNumber(settings.shippingFee);
    _freeShippingThresholdController.text =
        _formatNumber(settings.freeShippingThreshold);
    _minimumOrderAmountController.text =
        _formatNumber(settings.minimumOrderAmount);

    _lowStockThresholdController.text =
        settings.lowStockThreshold.toString();

    _currency = _currencies.contains(settings.currency)
        ? settings.currency
        : 'EGP';

    _storeEnabled = settings.storeEnabled;
    _acceptOrders = settings.storeEnabled && settings.acceptOrders;
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  String? _requiredTextValidator(
    String? value, {
    required String fieldName,
    int minLength = 1,
    int? maxLength,
  }) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return '$fieldName is required';
    }

    if (text.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    if (maxLength != null && text.length > maxLength) {
      return '$fieldName must not exceed $maxLength characters';
    }

    return null;
  }

  String? _optionalTextValidator(
    String? value, {
    required String fieldName,
    int? maxLength,
  }) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return null;
    }

    if (maxLength != null && text.length > maxLength) {
      return '$fieldName must not exceed $maxLength characters';
    }

    return null;
  }

  String? _emailValidator(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return null;
    }

    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    if (email.length > 254) {
      return 'Email is too long';
    }

    return null;
  }

  String? _phoneValidator(String? value) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return null;
    }

    if (phone.length < 7) {
      return 'Phone number is too short';
    }

    if (phone.length > 20) {
      return 'Phone number is too long';
    }

    final phoneRegex = RegExp(r'^[0-9+\-\s()]+$');

    if (!phoneRegex.hasMatch(phone)) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  String? _postalCodeValidator(String? value) {
    final postalCode = value?.trim() ?? '';

    if (postalCode.isEmpty) {
      return null;
    }

    if (postalCode.length > 20) {
      return 'Postal code is too long';
    }

    final postalCodeRegex = RegExp(r'^[a-zA-Z0-9\-\s]+$');

    if (!postalCodeRegex.hasMatch(postalCode)) {
      return 'Enter a valid postal code';
    }

    return null;
  }

  String? _decimalValidator(
    String? value, {
    required String fieldName,
    double minimum = 0,
    double? maximum,
  }) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return '$fieldName is required';
    }

    final number = double.tryParse(text);

    if (number == null || !number.isFinite) {
      return 'Enter a valid number';
    }

    if (number < minimum) {
      if (minimum == 0) {
        return '$fieldName cannot be negative';
      }

      return '$fieldName must be at least $minimum';
    }

    if (maximum != null && number > maximum) {
      return '$fieldName must be between $minimum and $maximum';
    }

    return null;
  }

  String? _integerValidator(
    String? value, {
    required String fieldName,
    int minimum = 0,
  }) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return '$fieldName is required';
    }

    final number = int.tryParse(text);

    if (number == null) {
      return '$fieldName must be a whole number';
    }

    if (number < minimum) {
      return '$fieldName cannot be negative';
    }

    return null;
  }

  void _saveSettings() {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final taxRate = double.tryParse(
      _taxRateController.text.trim(),
    );

    final shippingFee = double.tryParse(
      _shippingFeeController.text.trim(),
    );

    final freeShippingThreshold = double.tryParse(
      _freeShippingThresholdController.text.trim(),
    );

    final minimumOrderAmount = double.tryParse(
      _minimumOrderAmountController.text.trim(),
    );

    final lowStockThreshold = int.tryParse(
      _lowStockThresholdController.text.trim(),
    );

    if (taxRate == null ||
        shippingFee == null ||
        freeShippingThreshold == null ||
        minimumOrderAmount == null ||
        lowStockThreshold == null) {
      return;
    }

    final settings = AdminStoreSettings(
      storeName: _storeNameController.text.trim(),
      description: _descriptionController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      country: _countryController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
      currency: _currency,
      taxRate: taxRate,
      shippingFee: shippingFee,
      freeShippingThreshold: freeShippingThreshold,
      minimumOrderAmount: minimumOrderAmount,
      lowStockThreshold: lowStockThreshold,
      storeEnabled: _storeEnabled,
      acceptOrders: _storeEnabled && _acceptOrders,
    );

    context.read<AdminStoreSettingsCubit>().updateSettings(settings);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AdminStoreSettingsCubit>()..loadSettings(),
      child: BlocConsumer<AdminStoreSettingsCubit, AdminStoreSettingsState>(
        listener: (context, state) {
          if (state is AdminStoreSettingsLoaded) {
            _fillForm(state.settings);
          }

          if (state is AdminStoreSettingsSaved) {
            _fillForm(state.settings);

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text(
                    'Store settings updated successfully',
                  ),
                ),
              );
          }

          if (state is AdminStoreSettingsFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is AdminStoreSettingsLoading ||
              state is AdminStoreSettingsInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is AdminStoreSettingsFailure &&
              !_formInitialized) {
            return _ErrorView(
              message: state.message,
              onRetry: () {
                context
                    .read<AdminStoreSettingsCubit>()
                    .loadSettings();
              },
            );
          }

          final bool saving =
              state is AdminStoreSettingsLoaded && state.saving;

          return LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 900;

              return SingleChildScrollView(
                padding: EdgeInsets.all(
                  isDesktop ? 32 : 16,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 1100,
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidateMode:
                          AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          _buildHeader(context),
                          const SizedBox(height: 24),

                          _buildStoreInformationSection(
                            context,
                            isDesktop,
                          ),

                          const SizedBox(height: 24),

                          _buildCommerceSection(
                            context,
                            isDesktop,
                          ),

                          const SizedBox(height: 24),

                          _buildStoreStatusSection(
                            context,
                          ),

                          const SizedBox(height: 24),

                          _buildInventorySection(
                            context,
                            isDesktop,
                          ),

                          const SizedBox(height: 32),

                          _buildSaveButton(
                            context,
                            saving,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Store Settings',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Manage your store information, commerce settings, '
          'availability, and inventory preferences.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStoreInformationSection(
    BuildContext context,
    bool isDesktop,
  ) {
    return _SettingsSection(
      title: 'Store Information',
      icon: Icons.store_outlined,
      children: [
        _responsiveFields(
          isDesktop: isDesktop,
          children: [
            _buildTextField(
              controller: _storeNameController,
              label: 'Store Name',
              hint: 'Enter your store name',
              icon: Icons.store_outlined,
              validator: (value) {
                return _requiredTextValidator(
                  value,
                  fieldName: 'Store name',
                  minLength: 2,
                  maxLength: 100,
                );
              },
            ),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'store@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: _emailValidator,
            ),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone',
              hint: '+20 100 000 0000',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: _phoneValidator,
            ),
            _buildTextField(
              controller: _addressController,
              label: 'Address',
              hint: 'Store address',
              icon: Icons.location_on_outlined,
              validator: (value) {
                return _optionalTextValidator(
                  value,
                  fieldName: 'Address',
                  maxLength: 300,
                );
              },
            ),
            _buildTextField(
              controller: _cityController,
              label: 'City',
              hint: 'Cairo',
              icon: Icons.location_city_outlined,
              validator: (value) {
                return _optionalTextValidator(
                  value,
                  fieldName: 'City',
                  maxLength: 100,
                );
              },
            ),
            _buildTextField(
              controller: _countryController,
              label: 'Country',
              hint: 'Egypt',
              icon: Icons.public_outlined,
              validator: (value) {
                return _optionalTextValidator(
                  value,
                  fieldName: 'Country',
                  maxLength: 100,
                );
              },
            ),
            _buildTextField(
              controller: _postalCodeController,
              label: 'Postal Code',
              hint: '11511',
              icon: Icons.markunread_mailbox_outlined,
              keyboardType: TextInputType.text,
              validator: _postalCodeValidator,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _descriptionController,
          label: 'Description',
          hint: 'Describe your store',
          icon: Icons.description_outlined,
          maxLines: 4,
          maxLength: 1000,
          validator: (value) {
            return _optionalTextValidator(
              value,
              fieldName: 'Description',
              maxLength: 1000,
            );
          },
        ),
      ],
    );
  }

  Widget _buildCommerceSection(
    BuildContext context,
    bool isDesktop,
  ) {
    return _SettingsSection(
      title: 'Commerce',
      icon: Icons.shopping_cart_outlined,
      children: [
        _responsiveFields(
          isDesktop: isDesktop,
          children: [
            _buildCurrencyField(),
            _buildDecimalField(
              controller: _taxRateController,
              label: 'Tax Rate (%)',
              hint: '0',
              icon: Icons.percent_outlined,
              validator: (value) {
                return _decimalValidator(
                  value,
                  fieldName: 'Tax rate',
                  minimum: 0,
                  maximum: 100,
                );
              },
            ),
            _buildDecimalField(
              controller: _shippingFeeController,
              label: 'Shipping Fee',
              hint: '0',
              icon: Icons.local_shipping_outlined,
              validator: (value) {
                return _decimalValidator(
                  value,
                  fieldName: 'Shipping fee',
                );
              },
            ),
            _buildDecimalField(
              controller: _freeShippingThresholdController,
              label: 'Free Shipping Threshold',
              hint: '0',
              icon: Icons.local_shipping_outlined,
              validator: (value) {
                return _decimalValidator(
                  value,
                  fieldName: 'Free shipping threshold',
                );
              },
            ),
            _buildDecimalField(
              controller: _minimumOrderAmountController,
              label: 'Minimum Order Amount',
              hint: '0',
              icon: Icons.shopping_bag_outlined,
              validator: (value) {
                return _decimalValidator(
                  value,
                  fieldName: 'Minimum order amount',
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStoreStatusSection(
    BuildContext context,
  ) {
    return _SettingsSection(
      title: 'Store Status',
      icon: Icons.power_settings_new_outlined,
      children: [
        _buildSwitchTile(
          title: 'Store Enabled',
          subtitle: _storeEnabled
              ? 'Customers can access the store.'
              : 'The store is currently unavailable.',
          value: _storeEnabled,
          onChanged: (value) {
            setState(() {
              _storeEnabled = value;

              if (!value) {
                _acceptOrders = false;
              }
            });
          },
        ),
        const Divider(height: 1),
        _buildSwitchTile(
          title: 'Accept Orders',
          subtitle: !_storeEnabled
              ? 'Enable the store before accepting orders.'
              : _acceptOrders
                  ? 'Customers can place new orders.'
                  : 'New orders are currently disabled.',
          value: _acceptOrders,
          enabled: _storeEnabled,
          onChanged: (value) {
            setState(() {
              _acceptOrders = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildInventorySection(
    BuildContext context,
    bool isDesktop,
  ) {
    return _SettingsSection(
      title: 'Inventory',
      icon: Icons.inventory_2_outlined,
      children: [
        _responsiveFields(
          isDesktop: isDesktop,
          children: [
            _buildIntegerField(
              controller: _lowStockThresholdController,
              label: 'Low Stock Threshold',
              hint: '15',
              icon: Icons.warning_amber_outlined,
              validator: (value) {
                return _integerValidator(
                  value,
                  fieldName: 'Low stock threshold',
                  minimum: 0,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Products with stock at or below this value will appear '
          'in the dashboard low-inventory alerts.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color:
                    Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _buildCurrencyField() {
    return DropdownButtonFormField<String>(
      initialValue: _currency,
      decoration: const InputDecoration(
        labelText: 'Currency',
        hintText: 'Select currency',
        prefixIcon: Icon(Icons.currency_exchange_outlined),
        border: OutlineInputBorder(),
      ),
      items: _currencies.map((currency) {
        return DropdownMenuItem<String>(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          _currency = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Currency is required';
        }

        if (!_currencies.contains(value)) {
          return 'Select a valid currency';
        }

        return null;
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      textInputAction:
          maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        counterText: maxLength != null ? null : '',
      ),
    );
  }

  Widget _buildDecimalField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'^\d*\.?\d*'),
        ),
      ],
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildIntegerField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _responsiveFields({
    required bool isDesktop,
    required List<Widget> children,
  }) {
    if (!isDesktop) {
      return Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              const SizedBox(height: 16),
          ],
        ],
      );
    }

    final rows = <Widget>[];

    for (int i = 0; i < children.length; i += 2) {
      final first = children[i];
      final second =
          i + 1 < children.length ? children[i + 1] : null;

      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: first),
            const SizedBox(width: 16),
            Expanded(
              child: second ?? const SizedBox.shrink(),
            ),
          ],
        ),
      );

      if (i + 2 < children.length) {
        rows.add(const SizedBox(height: 16));
      }
    }

    return Column(
      children: rows,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(subtitle),
      ),
      value: value,
      onChanged: enabled ? onChanged : null,
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    bool saving,
  ) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        height: 50,
        child: ElevatedButton.icon(
          onPressed: saving ? null : _saveSettings,
          icon: saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.save_outlined),
          label: Text(
            saving ? 'Saving...' : 'Save Changes',
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load store settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
