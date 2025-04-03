import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kusel/screens/event/event_screen_state.dart';

final eventScreenProvider =
    StateNotifierProvider.autoDispose<EventScreenController, EventScreenState>(
        (ref) => EventScreenController());

class EventScreenController extends StateNotifier<EventScreenState> {
  EventScreenController() : super(EventScreenState.empty());

  Future<void> fetchAddress() async {
    String result = await getAddressFromLatLng(28.7041, 77.1025);
    state = state.copyWith(address: result);
  }
}

Future<String> getAddressFromLatLng(double lat, double lng) async {
  try {
    List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lng);
    if (placeMarks.isNotEmpty) {
      Placemark place = placeMarks.first;
      return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    }
  } catch (e) {
    return "Error: $e";
  }
  return "No Address Found";
}
