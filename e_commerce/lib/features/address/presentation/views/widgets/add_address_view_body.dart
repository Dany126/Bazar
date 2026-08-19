import 'package:e_commerce/features/address/domain/entity/address_entity.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_cubit.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../widgets/address_map.dart';
import '../widgets/address_text_field.dart';
import '../widgets/address_type_dependent_fields.dart';
import '../widgets/address_type_selector.dart';
import '../widgets/area_card.dart';
import '../widgets/label_description.dart';
import '../widgets/phone_field.dart';
import '../widgets/save_address_button.dart';

class AddAddressViewBody extends StatefulWidget {
  final AddressEntity? addressToEdit;
  const AddAddressViewBody({super.key, this.addressToEdit});

  @override
  State<AddAddressViewBody> createState() => _AddAddressViewBodyState();
}

class _AddAddressViewBodyState extends State<AddAddressViewBody> {
  late final FormGroup _form;
  bool get _isEditing => widget.addressToEdit != null;

  @override
  void initState() {
    super.initState();

    final a = widget.addressToEdit;

    _form = FormGroup({
      'addressType': FormControl<String>(value: a?.addressType ?? 'Apartment'),
      'buildingName': FormControl<String>(
        value: a?.buildingName,
        validators: [Validators.required],
      ),
      'apartmentNumber': FormControl<String>(
        value: a?.apartmentNumber,
        validators: [Validators.required],
      ),
      'houseName': FormControl<String>(value: a?.houseName),
      'houseNumber': FormControl<String>(value: a?.houseNumber),
      'officeName': FormControl<String>(value: a?.officeName),
      'officeNumber': FormControl<String>(value: a?.officeNumber),
      'floor': FormControl<String>(value: a?.floor),
      'phone': FormControl<String>(
        value: a?.phone ?? '+20 1226875031',
        validators: [Validators.required],
      ),
      'additionalDirections': FormControl<String>(
        value: a?.additionalDirections,
      ),
      'addressLabel': FormControl<String>(value: a?.addressLabel),
    });

    if (a != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AddressCubit>().startEditingAddress(a);
      });
    }
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  void _saveAddress() {
    _form.markAllAsTouched();
    if (!_form.valid) return;

    final location = context.read<AddressCubit>().pickedLocation;
    if (location == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location first')),
      );
      return;
    }
    if (location.city.trim().isEmpty ||
        location.postalCode.trim().isEmpty ||
        location.street.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not read the street, city, or postal code from the map.',
          ),
        ),
      );
      return;
    }

    final value = _form.value;
    final address = AddressEntity(
      id: widget.addressToEdit?.id,
      addressType: value['addressType'] as String,
      buildingName: value['buildingName'] as String?,
      apartmentNumber: value['apartmentNumber'] as String?,
      houseName: value['houseName'] as String?,
      houseNumber: value['houseNumber'] as String?,
      officeName: value['officeName'] as String?,
      officeNumber: value['officeNumber'] as String?,
      floor: value['floor'] as String?,
      street: location.street,
      phone: value['phone'] as String,
      additionalDirections: value['additionalDirections'] as String?,
      addressLabel: value['addressLabel'] as String?,
      latitude: location.latitude,
      longitude: location.longitude,
      city: location.city,
      country: location.country,
      postalCode: location.postalCode,
    );

    final cubit = context.read<AddressCubit>();
    _isEditing ? cubit.editAddress(address) : cubit.addAddress(address);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressCubit, AddressState>(
      listener: (context, state) {
        if (state is AddressError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message.message)));
        }
      },
      child: ReactiveForm(
        formGroup: _form,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const AddressMap(),
                    const SizedBox(height: 14),
                    const AreaCard(),
                    const SizedBox(height: 28),
                    AddressTypeSelector(form: _form),
                    const SizedBox(height: 24),
                    const AddressTypeDependentFields(),
                    const SizedBox(height: 12),
                    PhoneField(form: _form),
                    const SizedBox(height: 12),
                    const AddressTextField(
                      formControlName: 'additionalDirections',
                      hintText: 'Additional directions (optional)',
                    ),
                    const SizedBox(height: 12),
                    const AddressTextField(
                      formControlName: 'addressLabel',
                      hintText: 'Address label (optional)',
                    ),
                    const SizedBox(height: 8),
                    const LabelDescription(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SaveAddressButton(onPressed: _saveAddress),
          ],
        ),
      ),
    );
  }
}
