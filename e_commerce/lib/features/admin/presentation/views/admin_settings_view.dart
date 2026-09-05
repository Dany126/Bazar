import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_store_settings.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_store_settings_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_store_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSettingsView extends StatelessWidget {
  const AdminSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminStoreSettingsCubit>(
      create: (_) {
        final cubit = getIt<AdminStoreSettingsCubit>();
        cubit.loadSettings();
        return cubit;
      },
      child: const _AdminSettingsViewBody(),
    );
  }
}

class _AdminSettingsViewBody extends StatefulWidget {
  const _AdminSettingsViewBody();

  @override
  State<_AdminSettingsViewBody> createState() => _AdminSettingsViewBodyState();
}

class _AdminSettingsViewBodyState extends State<_AdminSettingsViewBody> {
  final _formKey = GlobalKey<FormState>();

  final _storeNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _postalCodeController = TextEditingController();

  final _taxRateController = TextEditingController();
  final _shippingFeeController = TextEditingController();
  final _freeShippingThresholdController = TextEditingController();
  final _minimumOrderAmountController = TextEditingController();

  final _lowStockThresholdController = TextEditingController();

  String _currency = 'EGP';

  bool _storeEnabled = true;
  bool _acceptOrders = true;

  bool _formInitialized = false;

  static const List<String> _currencies = ['EGP', 'USD', 'EUR', 'SAR', 'AED'];

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

  // ============================================================
  // LOAD SETTINGS INTO FORM
  // ============================================================

  void _fillForm(AdminStoreSettings settings, {bool force = false}) {
    if (_formInitialized && !force) {
      return;
    }

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

    _freeShippingThresholdController.text = _formatNumber(
      settings.freeShippingThreshold,
    );

    _minimumOrderAmountController.text = _formatNumber(
      settings.minimumOrderAmount,
    );

    _lowStockThresholdController.text = settings.lowStockThreshold.toString();

    _currency = _currencies.contains(settings.currency)
        ? settings.currency
        : 'EGP';

    _storeEnabled = settings.storeEnabled;
    _acceptOrders = settings.acceptOrders;

    if (mounted) {
      setState(() {});
    }
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  // ============================================================
  // SAVE
  // ============================================================

  void _saveSettings() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final taxRate = double.tryParse(_taxRateController.text.trim());

    final shippingFee = double.tryParse(_shippingFeeController.text.trim());

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

    // IMPORTANT:
    // This context is now BELOW BlocProvider.
    context.read<AdminStoreSettingsCubit>().updateSettings(settings);
  }

  // ============================================================
  // VALIDATORS
  // ============================================================

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final email = value.trim();

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? _numberValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    final number = double.tryParse(value.trim());

    if (number == null) {
      return 'Enter a valid number';
    }

    if (number < 0) {
      return '$fieldName cannot be negative';
    }

    return null;
  }

  String? _integerValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    final number = int.tryParse(value.trim());

    if (number == null) {
      return 'Enter a valid whole number';
    }

    if (number < 0) {
      return '$fieldName cannot be negative';
    }

    return null;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminStoreSettingsCubit, AdminStoreSettingsState>(
      listener: (context, state) {
        if (state is AdminStoreSettingsLoaded) {
          _fillForm(state.settings);
        }

        if (state is AdminStoreSettingsSaved) {
          _fillForm(state.settings, force: true);

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Store settings updated successfully'),
              ),
            );
        }

        if (state is AdminStoreSettingsFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is AdminStoreSettingsInitial ||
            state is AdminStoreSettingsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AdminStoreSettingsFailure && !_formInitialized) {
          return _ErrorView(
            message: state.message,
            onRetry: () {
              context.read<AdminStoreSettingsCubit>().loadSettings();
            },
          );
        }

        final saving = state is AdminStoreSettingsLoaded && state.saving;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            return SingleChildScrollView(
              padding: EdgeInsets.all(isDesktop ? 32 : 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),

                        const SizedBox(height: 24),

                        _buildStoreInformationSection(context, isDesktop),

                        const SizedBox(height: 24),

                        _buildCommerceSection(context, isDesktop),

                        const SizedBox(height: 24),

                        _buildStoreStatusSection(context),

                        const SizedBox(height: 24),

                        _buildInventorySection(context, isDesktop),

                        const SizedBox(height: 32),

                        _buildSaveButton(context, saving),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

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
          'Manage your store information, '
          'commerce settings and inventory.',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  // ============================================================
  // STORE INFORMATION
  // ============================================================

  Widget _buildStoreInformationSection(BuildContext context, bool isDesktop) {
    return _SettingsSection(
      title: 'Store Information',
      icon: Icons.store_outlined,
      children: [
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _storeNameController,
                  label: 'Store Name',
                  hint: 'Enter store name',
                  icon: Icons.store_outlined,
                  validator: (value) => _requiredValidator(value, 'Store name'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'store@example.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: _emailValidator,
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              _buildTextField(
                controller: _storeNameController,
                label: 'Store Name',
                hint: 'Enter store name',
                icon: Icons.store_outlined,
                validator: (value) => _requiredValidator(value, 'Store name'),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'store@example.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: _emailValidator,
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
          validator: (value) => _requiredValidator(value, 'Description'),
        ),

        const SizedBox(height: 16),

        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _phoneController,
                  label: 'Phone',
                  hint: 'Enter phone number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) => _requiredValidator(value, 'Phone'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _addressController,
                  label: 'Address',
                  hint: 'Enter store address',
                  icon: Icons.location_on_outlined,
                  validator: (value) => _requiredValidator(value, 'Address'),
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              _buildTextField(
                controller: _phoneController,
                label: 'Phone',
                hint: 'Enter phone number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) => _requiredValidator(value, 'Phone'),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _addressController,
                label: 'Address',
                hint: 'Enter store address',
                icon: Icons.location_on_outlined,
                validator: (value) => _requiredValidator(value, 'Address'),
              ),
            ],
          ),

        const SizedBox(height: 16),

        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _cityController,
                  label: 'City',
                  hint: 'Enter city',
                  icon: Icons.location_city_outlined,
                  validator: (value) => _requiredValidator(value, 'City'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _countryController,
                  label: 'Country',
                  hint: 'Enter country',
                  icon: Icons.public_outlined,
                  validator: (value) => _requiredValidator(value, 'Country'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _postalCodeController,
                  label: 'Postal Code',
                  hint: 'Enter postal code',
                  icon: Icons.markunread_mailbox_outlined,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      _requiredValidator(value, 'Postal code'),
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              _buildTextField(
                controller: _cityController,
                label: 'City',
                hint: 'Enter city',
                icon: Icons.location_city_outlined,
                validator: (value) => _requiredValidator(value, 'City'),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _countryController,
                label: 'Country',
                hint: 'Enter country',
                icon: Icons.public_outlined,
                validator: (value) => _requiredValidator(value, 'Country'),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _postalCodeController,
                label: 'Postal Code',
                hint: 'Enter postal code',
                icon: Icons.markunread_mailbox_outlined,
                keyboardType: TextInputType.number,
                validator: (value) => _requiredValidator(value, 'Postal code'),
              ),
            ],
          ),
      ],
    );
  }

  // ============================================================
  // COMMERCE
  // ============================================================

  Widget _buildCommerceSection(BuildContext context, bool isDesktop) {
    return _SettingsSection(
      title: 'Commerce',
      icon: Icons.shopping_cart_outlined,
      children: [
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildNumberField(
                  controller: _taxRateController,
                  label: 'Tax Rate (%)',
                  hint: '0',
                  validator: (value) {
                    final error = _numberValidator(value, 'Tax rate');

                    if (error != null) {
                      return error;
                    }

                    final number = double.tryParse(value!.trim());

                    if (number != null && number > 100) {
                      return 'Tax rate cannot exceed 100%';
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNumberField(
                  controller: _shippingFeeController,
                  label: 'Shipping Fee',
                  hint: '0',
                  validator: (value) => _numberValidator(value, 'Shipping fee'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNumberField(
                  controller: _freeShippingThresholdController,
                  label: 'Free Shipping Threshold',
                  hint: '0',
                  validator: (value) =>
                      _numberValidator(value, 'Free shipping threshold'),
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              _buildNumberField(
                controller: _taxRateController,
                label: 'Tax Rate (%)',
                hint: '0',
                validator: (value) {
                  final error = _numberValidator(value, 'Tax rate');

                  if (error != null) {
                    return error;
                  }

                  final number = double.tryParse(value!.trim());

                  if (number != null && number > 100) {
                    return 'Tax rate cannot exceed 100%';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildNumberField(
                controller: _shippingFeeController,
                label: 'Shipping Fee',
                hint: '0',
                validator: (value) => _numberValidator(value, 'Shipping fee'),
              ),
              const SizedBox(height: 16),
              _buildNumberField(
                controller: _freeShippingThresholdController,
                label: 'Free Shipping Threshold',
                hint: '0',
                validator: (value) =>
                    _numberValidator(value, 'Free shipping threshold'),
              ),
            ],
          ),

        const SizedBox(height: 16),

        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildNumberField(
                  controller: _minimumOrderAmountController,
                  label: 'Minimum Order Amount',
                  hint: '0',
                  validator: (value) =>
                      _numberValidator(value, 'Minimum order amount'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildCurrencyDropdown()),
            ],
          )
        else
          Column(
            children: [
              _buildNumberField(
                controller: _minimumOrderAmountController,
                label: 'Minimum Order Amount',
                hint: '0',
                validator: (value) =>
                    _numberValidator(value, 'Minimum order amount'),
              ),
              const SizedBox(height: 16),
              _buildCurrencyDropdown(),
            ],
          ),
      ],
    );
  }

  // ============================================================
  // STATUS
  // ============================================================

  Widget _buildStoreStatusSection(BuildContext context) {
    return _SettingsSection(
      title: 'Store Status',
      icon: Icons.settings_outlined,
      children: [
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Store Enabled',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            _storeEnabled
                ? 'Your store is currently active.'
                : 'Your store is currently disabled.',
          ),
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
        const Divider(height: 24),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Accept Orders',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            !_storeEnabled
                ? 'Enable the store first to accept orders.'
                : _acceptOrders
                ? 'Customers can place orders.'
                : 'Customers cannot place orders.',
          ),
          value: _acceptOrders,
          onChanged: !_storeEnabled
              ? null
              : (value) {
                  setState(() {
                    _acceptOrders = value;
                  });
                },
        ),
      ],
    );
  }

  // ============================================================
  // INVENTORY
  // ============================================================

  Widget _buildInventorySection(BuildContext context, bool isDesktop) {
    return _SettingsSection(
      title: 'Inventory',
      icon: Icons.inventory_2_outlined,
      children: [
        _buildNumberField(
          controller: _lowStockThresholdController,
          label: 'Low Stock Threshold',
          hint: '15',
          integerOnly: true,
          validator: (value) => _integerValidator(value, 'Low stock threshold'),
        ),
      ],
    );
  }

  // ============================================================
  // SAVE BUTTON
  // ============================================================

  Widget _buildSaveButton(BuildContext context, bool saving) {
    return Align(
      alignment: Alignment.centerRight,
      child: FilledButton.icon(
        onPressed: saving ? null : _saveSettings,
        icon: saving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save_outlined),
        label: Text(saving ? 'Saving...' : 'Save Settings'),
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  // ============================================================
  // NUMBER FIELD
  // ============================================================

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    bool integerOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: !integerOnly),
      inputFormatters: [
        if (integerOnly)
          FilteringTextInputFormatter.digitsOnly
        else
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: const Icon(Icons.numbers_outlined),
        border: const OutlineInputBorder(),
      ),
    );
  }

  // ============================================================
  // CURRENCY
  // ============================================================

  Widget _buildCurrencyDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _currency,
      decoration: const InputDecoration(
        labelText: 'Currency',
        prefixIcon: Icon(Icons.currency_exchange_outlined),
        border: OutlineInputBorder(),
      ),
      items: _currencies.map((currency) {
        return DropdownMenuItem<String>(value: currency, child: Text(currency));
      }).toList(),
      onChanged: (value) {
        if (value == null) {
          return;
        }

        setState(() {
          _currency = value;
        });
      },
    );
  }
}

// ================================================================
// SECTION
// ================================================================

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
                Icon(icon, color: theme.colorScheme.primary),
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

// ================================================================
// ERROR
// ================================================================

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Unable to load store settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
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
