import 'package:e_commerce/features/address/presentation/model_view/cubit/address_cubit.dart';
import 'package:e_commerce/features/address/presentation/views/search_location_view.dart';
import 'package:e_commerce/features/address/presentation/views/widgets/map_view_body.dart';
import 'package:e_commerce/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});
  static const String routeName = '/map';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'Map',
          actions: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<AddressCubit>(),
                      child: const SearchLocationView(),
                    ),
                  ),
                );
              },
              child: const Icon(Icons.search, color: Colors.black),
            ),
          ),
        ),
      ),
      body: const SafeArea(child: MapViewBody()),
    );
  }
}
