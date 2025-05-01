import 'package:domain/model/response_model/event_details/event_details_response_model.dart';
import 'package:domain/model/request_model/event_details/event_details_request_model.dart';
import 'package:domain/usecase/event_details/event_details_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kusel/screens/event/event_detail_screen_state.dart';
import 'package:url_launcher/url_launcher.dart';

final eventDetailScreenProvider =
    StateNotifierProvider<EventDetailScreenController, EventDetailScreenState>(
        (ref) => EventDetailScreenController(
              eventDetailsUseCase: ref.read(eventDetailsUseCaseProvider),
            ));

class EventDetailScreenController extends StateNotifier<EventDetailScreenState> {
  EventDetailScreenController({required this.eventDetailsUseCase})
      : super(EventDetailScreenState.empty());

  EventDetailsUseCase eventDetailsUseCase;

  Future<void> fetchAddress() async {
    String result = await getAddressFromLatLng(28.7041, 77.1025);
    state = state.copyWith(address: result);
  }

  Future<void> getEventDetails(int? eventId) async {
    if (eventId != null) {
      try {
        state = state.copyWith(loading: true, error: "");

        GetEventDetailsRequestModel getEventDetailsRequestModel =
            GetEventDetailsRequestModel(id: eventId);

        GetEventDetailsResponseModel getEventDetailsResponseModel =
            GetEventDetailsResponseModel();
        final result = await eventDetailsUseCase.call(
            getEventDetailsRequestModel, getEventDetailsResponseModel);
        result.fold(
          (l) {
            state = state.copyWith(loading: false, error: l.toString());
          },
          (r) {
            var eventData = (r as GetEventDetailsResponseModel).data;
            state = state.copyWith(eventDetails: eventData, loading: false);
          },
        );
      } catch (error) {
        state = state.copyWith(loading: false, error: error.toString());
      }
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

  void openInMaps(double latitude, double longitude) async {
    final Uri geoUri = Uri.parse('geo:$latitude,$longitude');
    final Uri webUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch any map app or browser.';
    }
  }
}

class EventDetailScreenParams {
  int? eventId;

  EventDetailScreenParams({required this.eventId});
}
