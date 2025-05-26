import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/common_widgets/map_widget/custom_flutter_map_state.dart';

final customFlutterMapProvider =
StateNotifierProvider<CustomFlutterMapProvider, CustomFlutterMapState>(
        (ref) => CustomFlutterMapProvider());

class CustomFlutterMapProvider extends StateNotifier<CustomFlutterMapState> {
  CustomFlutterMapProvider() : super(CustomFlutterMapState.empty());

  MapController mapController = MapController();

  void initializeRotation() {
    mapController.mapEventStream.listen((event) {
      state = state.copyWith(currentRotation: mapController.camera.rotation);
    });
  }
}
