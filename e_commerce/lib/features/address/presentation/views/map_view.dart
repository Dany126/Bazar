import 'package:e_commerce/features/address/presentation/views/widgets/map_view_body.dart';
import 'package:e_commerce/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});
  static const String routeName = '/map';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Map'),
      ),
      body: SafeArea(child: MapViewBody()),
    );
  }
}
