import 'package:e_commerce/features/address/presentation/model_view/cubit/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AddressMap extends StatefulWidget {
  const AddressMap({super.key});

  @override
  State<AddressMap> createState() => _AddressMapState();
}

class _AddressMapState extends State<AddressMap> {
  final MapController _mapController = MapController();
  static const _fallback = LatLng(30.0444, 31.2357);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<AddressCubit>();
      final picked = cubit.pickedLocation;
      if (picked != null) {
        _mapController.move(LatLng(picked.latitude, picked.longitude), 17);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _fallback,
                initialZoom: 15,
                onPositionChanged: (position, hasGesture) {
                  context.read<AddressCubit>().onMapMove(position.center);
                  if (hasGesture) context.read<AddressCubit>().onMapIdle();
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.e_commerce',
                ),
              ],
            ),
            const IgnorePointer(
              child: Icon(
                Icons.location_pin,
                size: 40,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
