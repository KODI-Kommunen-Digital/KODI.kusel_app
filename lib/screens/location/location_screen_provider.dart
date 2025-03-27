import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'location_screen_state.dart';

final locationScreenProvider =
StateNotifierProvider.autoDispose<LocationScreenProvider, LocationScreenState>(
        (ref) => LocationScreenProvider());

class LocationScreenProvider extends StateNotifier<LocationScreenState> {
  LocationScreenProvider() : super(LocationScreenState.empty());
}
