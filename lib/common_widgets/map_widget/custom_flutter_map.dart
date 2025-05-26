import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/map_widget/custom_flutter_map_provider.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

import '../text_styles.dart';

class CustomFlutterMap extends ConsumerStatefulWidget {
  final double latitude;
  final double longitude;
  final double height;
  final double width;
  final double initialZoom;
  final Function() onMapTap;

  const CustomFlutterMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.height,
    required this.width,
    required this.initialZoom,
    required this.onMapTap,
  });

  @override
  ConsumerState<CustomFlutterMap> createState() => _CustomFlutterMapState();
}

class _CustomFlutterMapState extends ConsumerState<CustomFlutterMap> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    ref.read(customFlutterMapProvider.notifier).initializeRotation();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(customFlutterMapProvider);
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: [
          _customMapWidget(),
          Positioned(
            bottom: 10,
            right: 10,
            child: Column(
              children: [
                textBoldPoppins(text: "N", fontSize: 10, color: Theme.of(context).colorScheme.error),
                GestureDetector(
                  onTap: () => _mapController.rotate(0),
                  child: Transform.rotate(
                    angle: -state.currentRotation * math.pi / 180,
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
                      ),
                      child: Transform.rotate(
                        angle: -10.25,
                          child: Icon(Icons.explore, color: Theme.of(context).primaryColor, size: 20.h)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: FloatingActionButton(
              mini: true,
              heroTag: "recenter",
              onPressed: _resetMap,
              backgroundColor: Theme.of(context).canvasColor,
              child: Icon(
                Icons.my_location,
                color: Theme.of(context).primaryColor,
                size: 16.h.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customMapWidget() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        onTap: (tapPosition, latLong) => widget.onMapTap(),
        initialCenter: LatLng(widget.latitude, widget.longitude),
        initialZoom: widget.initialZoom,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 35.w,
              height: 35.h,
              point: LatLng(widget.latitude, widget.longitude),
              child: Icon(
                Icons.location_pin,
                color: Theme.of(context).colorScheme.onTertiaryFixed,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _resetMap() {
    _mapController.move(
      LatLng(widget.latitude, widget.longitude),
      widget.initialZoom,
    );
    _mapController.rotate(0);
  }
}
