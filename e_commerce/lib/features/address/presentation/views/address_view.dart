import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/widgets/custom_app_bar.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_cubit.dart';
import 'package:e_commerce/features/address/presentation/views/map_view.dart';
import 'package:e_commerce/features/address/presentation/views/widgets/address_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressView extends StatelessWidget {
  static const String routeName = '/address';

  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddressCubit>(
      create: (_) => getIt<AddressCubit>()..loadAddresses(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Addresses',
          actions: Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<AddressCubit>(),
                        child: const MapView(),
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(21),
                child: Ink(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: Colors.black87),
                ),
              ),
            ),
          ),
        ),
        body: const SafeArea(child: AddressViewBody()),
      ),
    );
  }
}
