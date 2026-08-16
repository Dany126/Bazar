import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_cubit.dart';
import 'package:e_commerce/features/address/presentation/views/widgets/address_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressView extends StatelessWidget {
  static const String routeName = '/address';

  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddressCubit>(
      create: (_) => getIt<AddressCubit>()..getAddresses(),
      child: const Scaffold(body: SafeArea(child: AddressViewBody())),
    );
  }
}
