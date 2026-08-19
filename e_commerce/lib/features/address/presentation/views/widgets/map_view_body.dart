import 'package:e_commerce/core/widgets/custom_button.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_cubit.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_state.dart';
import 'package:e_commerce/features/address/presentation/views/add_address_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MapViewBody extends StatefulWidget {
  const MapViewBody({super.key});

  @override
  State<MapViewBody> createState() => _MapViewBodyState();
}

class _MapViewBodyState extends State<MapViewBody> {
  final MapController _mapController = MapController();
  static const _fallback = LatLng(30.0444, 31.2357);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final target = await context.read<AddressCubit>().loadInitialLocation();
      if (target != null) {
        _mapController.move(target, 17);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressCubit, AddressState>(
      listenWhen: (previous, current) =>
          current is AddressLocationPicked && current.recenter,
      listener: (context, state) {
        final location = (state as AddressLocationPicked).location;
        _mapController.move(LatLng(location.latitude, location.longitude), 17);
      },
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _fallback,
              initialZoom: 10.0,
              onPositionChanged: (position, hasGesture) {
                context.read<AddressCubit>().onMapMove(position.center);
                if (hasGesture) {
                  context.read<AddressCubit>().onMapIdle();
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.e_commerce',
                maxZoom: 19,
              ),
            ],
          ),

          const IgnorePointer(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Icon(
                  Icons.location_pin,
                  size: 44,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),

          Positioned(
            right: 16,
            bottom: MediaQuery.of(context).size.height * 0.1 + 16,
            child: FloatingActionButton.small(
              heroTag: 'locate_me',
              onPressed: () async {
                final target = await context
                    .read<AddressCubit>()
                    .loadInitialLocation();
                if (target != null) {
                  _mapController.move(target, 17);
                }
              },
              child: const Icon(Icons.my_location),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BlocBuilder<AddressCubit, AddressState>(
                    builder: (context, state) {
                      final isLoading =
                          state is AddressLocating || state is AddressResolving;
                      final isReady =
                          state is AddressLocationPicked ||
                          context.read<AddressCubit>().pickedLocation != null;

                      return Skeletonizer(
                        enabled: isLoading,
                        child: CustomButton(
                          onTap: isReady
                              ? () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<AddressCubit>(),
                                        child: const AddAddressView(),
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          text: 'Enter Complete Address',
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
