import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapViewBody extends StatefulWidget {
  const MapViewBody({super.key});

  @override
  State<MapViewBody> createState() => _MapViewBodyState();
}

class _MapViewBodyState extends State<MapViewBody> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(51.5, -0.09),
            initialZoom: 10.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.e_commerce',

              maxZoom: 19,
            ),
          ],
        ),
      ],
    );
  }
}
