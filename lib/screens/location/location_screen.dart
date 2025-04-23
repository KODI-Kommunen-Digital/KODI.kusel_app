import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:latlong2/latlong.dart';

class LocationScreen extends ConsumerStatefulWidget {
  const LocationScreen({super.key});

  @override
  ConsumerState<LocationScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(context),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return SlidingUpPanel(
      body: FlutterMap(options: MapOptions(
        onTap: (tapPosition, LatLng latLong) {

        },
        initialCenter: LatLng(49.53838,7.40647 ),
        initialZoom: 13.0,
        interactionOptions: InteractionOptions(),
      ), children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 35.w,
              height: 35.h,
              point: LatLng(49.53838,7.40647),
              child: Icon(Icons.location_pin, color: Theme.of(context).colorScheme.onTertiaryFixed),
            ),

            Marker(
              width: 35.w,
              height: 35.h,
              point: LatLng(49.53348,7.40647),
              child: Icon(Icons.location_pin, color: Theme.of(context).colorScheme.onTertiaryFixed),
            )
          ],
        )
      ],),
      panelBuilder: (controller){
        return Center(
          child: Text("Hello"),
        );
      },
    );
  }
}
