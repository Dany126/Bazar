import 'dart:developer';

import 'package:e_commerce/core/widgets/custom_app_bar.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_cubit.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_state.dart';
import 'package:e_commerce/features/address/presentation/views/widgets/add_address_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAddressView extends StatelessWidget {
  const AddAddressView({super.key});

  static const String routeName = '/add-address';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'New address'),
      body: BlocListener<AddressCubit, AddressState>(
        listener: (context, state) {
          if (state is AddressLoaded) {
            Navigator.of(context).pop(true);
          }

          if (state is AddressError) {
            log(state.message.message);

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message.message)));
          }
        },
        child: const AddAddressViewBody(),
      ),
    );
  }
}
