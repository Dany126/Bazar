import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_store_settings.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_store_settings_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_store_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSettingsView extends StatelessWidget {
  const AdminSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AdminStoreSettingsCubit>()..loadSettings(),
      child: const _AdminSettingsBody(),
    );
  }
}

class _AdminSettingsBody extends StatefulWidget {
  const _AdminSettingsBody();

  @override
  State<_AdminSettingsBody> createState() => _AdminSettingsBodyState();
}

class _AdminSettingsBodyState extends State<_AdminSettingsBody> {
  final _formKey = GlobalKey<FormState>();

  final _storeNameController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _emailController = TextEditingController();

  final _phoneController = TextEditingController();

  final _addressController = TextEditingController();

  final _cityController = TextEditingController();

  final _countryController = TextEditingController();

  final _postalCodeController = TextEditingController();

  final _taxController = TextEditingController();

  final _shippingController = TextEditingController();

  final _freeShippingController = TextEditingController();

  final _minimumOrderController = TextEditingController();

  final _lowStockController = TextEditingController();

  String _currency = 'EGP';

  bool _storeEnabled = true;
  bool _acceptOrders = true;

  bool _initialized = false;

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
    _taxController.dispose();
    _shippingController.dispose();
    _freeShippingController.dispose();
    _minimumOrderController.dispose();
    _lowStockController.dispose();

    super.dispose();
  }

  void _fillForm(AdminStoreSettings settings) {
    if (_initialized) return;

    _initialized = true;

    _storeNameController.text = settings.storeName;

    _descriptionController.text = settings.description;

    _emailController.text = settings.email;

    _phoneController.text = settings.phone;

    _addressController.text = settings.address;

    _cityController.text = settings.city;

    _countryController.text = settings.country;

    _postalCodeController.text = settings.postalCode;

    _taxController.text = _numberText(settings.taxRate);

    _shippingController.text = _numberText(settings.shippingFee);

    _freeShippingController.text = _numberText(settings.freeShippingThreshold);

    _minimumOrderController.text = _numberText(settings.minimumOrderAmount);

    _lowStockController.text = settings.lowStockThreshold.toString();

    _currency = settings.currency;
    _storeEnabled = settings.storeEnabled;
    _acceptOrders = settings.acceptOrders;
  }

  String _numberText(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  double _doubleValue(TextEditingController controller) {
    return double.tryParse(controller.text.trim()) ?? 0;
  }

  int _intValue(TextEditingController controller) {
    return int.tryParse(controller.text.trim()) ?? 0;
  }

  void _save(BuildContext context, AdminStoreSettings current) {
    if (!_formKey.currentState!.validate()) {
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
      taxRate: _doubleValue(_taxController),
      shippingFee: _doubleValue(_shippingController),
      freeShippingThreshold: _doubleValue(_freeShippingController),
      minimumOrderAmount: _doubleValue(_minimumOrderController),
      lowStockThreshold: _intValue(_lowStockController),
      storeEnabled: _storeEnabled,
      acceptOrders: _acceptOrders,
    );

    context.read<AdminStoreSettingsCubit>().updateSettings(settings);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminStoreSettingsCubit, AdminStoreSettingsState>(
      listener: (context, state) {
        if (state is AdminStoreSettingsSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Store settings saved successfully')),
          );
        }

        if (state is AdminStoreSettingsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is AdminStoreSettingsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AdminStoreSettingsFailure) {
          return _ErrorView(
            message: state.message,
            onRetry: () {
              context.read<AdminStoreSettingsCubit>().loadSettings();
            },
          );
        }

        AdminStoreSettings? settings;

        if (state is AdminStoreSettingsLoaded) {
          settings = state.settings;
        }

        if (state is AdminStoreSettingsSaved) {
          settings = state.settings;
        }

        if (settings == null) {
          return const Center(child: CircularProgressIndicator());
        }

        _fillForm(settings);

        final saving = state is AdminStoreSettingsLoaded && state.saving;

        return _buildContent(context, settings, saving);
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    AdminStoreSettings settings,
    bool saving,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1050),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),

                const SizedBox(height: 28),

                _buildSection(
                  title: 'Store Information',
                  icon: Icons.store_outlined,
                  child: _buildStoreInformation(),
                ),

                const SizedBox(height: 24),

                _buildSection(
                  title: 'Commerce',
                  icon: Icons.payments_outlined,
                  child: _buildCommerceSection(),
                ),

                const SizedBox(height: 24),

                _buildSection(
                  title: 'Store Status',
                  icon: Icons.storefront_outlined,
                  child: _buildStatusSection(),
                ),

                const SizedBox(height: 24),

                _buildSection(
                  title: 'Inventory',
                  icon: Icons.inventory_2_outlined,
                  child: _buildInventorySection(),
                ),

                const SizedBox(height: 28),

                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: saving ? null : () => _save(context, settings),
                      icon: saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(saving ? 'Saving...' : 'Save Changes'),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Store Settings',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage your store information, commerce rules, and availability.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildStoreInformation() {
    return Column(
      children: [
        _textField(
          controller: _storeNameController,
          label: 'Store Name',
          icon: Icons.store_outlined,
          requiredField: true,
        ),

        const SizedBox(height: 16),

        _textField(
          controller: _descriptionController,
          label: 'Description',
          icon: Icons.description_outlined,
          maxLines: 3,
        ),

        const SizedBox(height: 16),

        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 650) {
              return Column(
                children: [
                  _textField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _textField(
                    controller: _phoneController,
                    label: 'Phone',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: _textField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _textField(
                    controller: _phoneController,
                    label: 'Phone',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        _textField(
          controller: _addressController,
          label: 'Address',
          icon: Icons.location_on_outlined,
        ),

        const SizedBox(height: 16),

        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 650) {
              return Column(
                children: [
                  _textField(controller: _cityController, label: 'City'),
                  const SizedBox(height: 16),
                  _textField(controller: _countryController, label: 'Country'),
                  const SizedBox(height: 16),
                  _textField(
                    controller: _postalCodeController,
                    label: 'Postal Code',
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: _textField(controller: _cityController, label: 'City'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _textField(
                    controller: _countryController,
                    label: 'Country',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _textField(
                    controller: _postalCodeController,
                    label: 'Postal Code',
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildCommerceSection() {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 650) {
              return Column(
                children: [
                  _currencyDropdown(),
                  const SizedBox(height: 16),
                  _numberField(
                    controller: _taxController,
                    label: 'Tax Rate (%)',
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: _currencyDropdown()),
                const SizedBox(width: 16),
                Expanded(
                  child: _numberField(
                    controller: _taxController,
                    label: 'Tax Rate (%)',
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 650) {
              return Column(
                children: [
                  _numberField(
                    controller: _shippingController,
                    label: 'Shipping Fee',
                  ),
                  const SizedBox(height: 16),
                  _numberField(
                    controller: _freeShippingController,
                    label: 'Free Shipping Above',
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: _numberField(
                    controller: _shippingController,
                    label: 'Shipping Fee',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _numberField(
                    controller: _freeShippingController,
                    label: 'Free Shipping Above',
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        _numberField(
          controller: _minimumOrderController,
          label: 'Minimum Order Amount',
        ),
      ],
    );
  }

  Widget _buildStatusSection() {
    return Column(
      children: [
        _switchTile(
          title: 'Store Enabled',
          subtitle: 'Customers can access the store.',
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

        const Divider(),

        _switchTile(
          title: 'Accept Orders',
          subtitle: 'Allow customers to place new orders.',
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

  Widget _buildInventorySection() {
    return _numberField(
      controller: _lowStockController,
      label: 'Low Stock Threshold',
      integerOnly: true,
    );
  }

  Widget _currencyDropdown() {
    return DropdownButtonFormField<String>(
      value: _currency,
      decoration: const InputDecoration(
        labelText: 'Currency',
        prefixIcon: Icon(Icons.currency_exchange),
      ),
      items: const [
        DropdownMenuItem(value: 'EGP', child: Text('EGP - Egyptian Pound')),
        DropdownMenuItem(value: 'USD', child: Text('USD - US Dollar')),
        DropdownMenuItem(value: 'EUR', child: Text('EUR - Euro')),
        DropdownMenuItem(value: 'SAR', child: Text('SAR - Saudi Riyal')),
        DropdownMenuItem(value: 'AED', child: Text('AED - UAE Dirham')),
      ],
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          _currency = value;
        });
      },
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool requiredField = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon),
      ),
      validator: requiredField
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label is required';
              }

              return null;
            }
          : null,
    );
  }

  Widget _numberField({
    required TextEditingController controller,
    required String label,
    bool integerOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: !integerOnly),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.numbers_outlined),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Enter $label';
        }

        final number = integerOnly
            ? int.tryParse(value.trim())
            : double.tryParse(value.trim());

        if (number == null) {
          return 'Enter a valid number';
        }

        if (number < 0) {
          return 'Value cannot be negative';
        }

        if (!integerOnly && label == 'Tax Rate (%)' && number > 100) {
          return 'Tax rate cannot exceed 100%';
        }

        return null;
      },
    );
  }

  Widget _switchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 12),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
