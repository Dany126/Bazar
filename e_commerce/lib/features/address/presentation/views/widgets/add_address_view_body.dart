import 'package:e_commerce/features/address/presentation/model_view/cubit/address_cubit.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'address_map.dart';
import 'address_text_field.dart';
import 'address_type_dependent_fields.dart';
import 'address_type_selector.dart';

import 'area_card.dart';
import 'label_description.dart';
import 'phone_field.dart';
import 'save_address_button.dart';

class AddAddressViewBody extends StatefulWidget {
  const AddAddressViewBody({super.key});

  @override
  State<AddAddressViewBody> createState() => _AddAddressViewBodyState();
}

class _AddAddressViewBodyState extends State<AddAddressViewBody> {
  late final FormGroup _form;

  @override
  void initState() {
    super.initState();

    _form = FormGroup({
      'addressType': FormControl<String>(value: 'Apartment'),

      'buildingName': FormControl<String>(validators: [Validators.required]),

      'apartmentNumber': FormControl<String>(validators: [Validators.required]),

      'houseName': FormControl<String>(),

      'houseNumber': FormControl<String>(),

      'officeName': FormControl<String>(),

      'officeNumber': FormControl<String>(),

      'floor': FormControl<String>(),

      'street': FormControl<String>(validators: [Validators.required]),

      'phone': FormControl<String>(
        value: '+20 1226875031',
        validators: [Validators.required],
      ),

      'additionalDirections': FormControl<String>(),

      'addressLabel': FormControl<String>(),
    });
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  void _saveAddress() {
    _form.markAllAsTouched();

    if (!_form.valid) {
      return;
    }

    final value = _form.value;

    context.read<AddressCubit>().addAddress(
      street: value['street'] as String,
      city: 'Ain Shams - El Sharqeya',
      country: 'Egypt',
      postalCode: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressCubit, AddressState>(
      listener: (context, state) {
        if (state is AddressLoaded) {
          Navigator.of(context).pop();
        }

        if (state is AddressError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
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

                    const AddressTextField(
                      formControlName: 'street',
                      hintText: 'Street',
                    ),

                    const SizedBox(height: 12),

                    const PhoneField(),

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
