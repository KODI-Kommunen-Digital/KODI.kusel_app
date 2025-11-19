import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/device_helper.dart';
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
  final List<Marker> markersList;

  const CustomFlutterMap(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.height,
      required this.width,
      required this.initialZoom,
      required this.onMapTap,
      required this.markersList});

  @override
  ConsumerState<CustomFlutterMap> createState() => _CustomFlutterMapState();
}

class _CustomFlutterMapState extends ConsumerState<CustomFlutterMap> {
  final MapController _mapController = MapController();
  double _currentRotation = 0;

  @override
  void initState() {
    super.initState();
    _mapController.mapEventStream.listen((event) {
      setState(() {
        _currentRotation = _mapController.camera.rotation;
      });
    });
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
          // Positioned(
          //   top: 10.h,
          //   right: 8.w,
          //   child: Column(
          //     children: [
          //       textBoldPoppins(
          //           text: "N",
          //           fontSize: 10,
          //           color: Theme.of(context).colorScheme.error),
          //       InkWell(
          //         onTap: () => _mapController.rotate(0),
          //         child: Transform.rotate(
          //           angle: -_currentRotation * math.pi / 180,
          //           child: Card(
          //             elevation: 4,
          //             shape: const CircleBorder(),
          //             child: Container(
          //               padding: EdgeInsets.all(5.h.w),
          //               decoration: BoxDecoration(
          //                 shape: BoxShape.circle,
          //                 color: Colors.white,
          //                 boxShadow: [
          //                   BoxShadow(blurRadius: 4, color: Colors.black26)
          //                 ],
          //               ),
          //               child: Transform.rotate(
          //                   angle: -10.25,
          //                   child: Icon(Icons.explore,
          //                       color: Theme.of(context).primaryColor,
          //                       size: 20.h)),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // DeviceHelper.isMobile(context)
          //     ? Positioned(
          //         top: 30.h,
          //         right: 7.w,
          //         child: Icon(
          //           Icons.my_location,
          //           color: Theme.of(context).primaryColor,
          //           size: 16.h.w,
          //         ),
          //       )
          //     : Positioned(
          //         top: 80.h,
          //         right: 10.w,
          //         child: GestureDetector(
          //           onTap: _resetMap,
          //           child: Material(
          //             elevation: 4,
          //             shape: const CircleBorder(),
          //             color: Theme.of(context).canvasColor,
          //             child: Container(
          //               width: 40.h,
          //               // Or any size you prefer
          //               height: 40.h,
          //               alignment: Alignment.center,
          //               decoration: BoxDecoration(
          //                 shape: BoxShape.circle,
          //               ),
          //               child: Icon(
          //                 Icons.my_location,
          //                 color: Theme.of(context).primaryColor,
          //                 size: 12.h.w,
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
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
        interactionOptions: InteractionOptions(
            flags:
                // InteractiveFlag.pinchZoom |
                //     InteractiveFlag.drag |
                InteractiveFlag.flingAnimation |
                    InteractiveFlag.doubleTapZoom |
                    InteractiveFlag.scrollWheelZoom),
      ),
      children: [
        TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "de.landkreiskusel.app"),
        MarkerLayer(
          markers: widget.markersList,
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

  @override
  void didUpdateWidget(covariant CustomFlutterMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldLatLng = LatLng(oldWidget.latitude, oldWidget.longitude);
    final newLatLng = LatLng(widget.latitude, widget.longitude);

    if (oldLatLng != newLatLng) {
      _mapController.move(newLatLng, widget.initialZoom);
    }
  }
}
