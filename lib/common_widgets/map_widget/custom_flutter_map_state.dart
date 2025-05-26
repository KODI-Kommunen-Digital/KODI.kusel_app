import 'dart:core';

import 'package:flutter_map/flutter_map.dart';

class CustomFlutterMapState {
  double currentRotation;

  MapController mapController;

  CustomFlutterMapState(this.currentRotation, this.mapController);

  factory CustomFlutterMapState.empty() {
    return CustomFlutterMapState(0, MapController());
  }

  CustomFlutterMapState copyWith(
      {double? currentRotation, MapController? mapController}) {
    return CustomFlutterMapState(currentRotation ?? this.currentRotation,
        mapController ?? this.mapController);
  }
}
