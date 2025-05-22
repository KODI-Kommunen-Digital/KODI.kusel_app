import 'package:domain/model/request_model/event_details/event_details_request_model.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/response_model/event_details/event_details_response_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/event_details/event_details_usecase.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kusel/screens/event/event_detail_screen_state.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:url_launcher/url_launcher.dart';

final eventDetailScreenProvider =
    StateNotifierProvider.autoDispose<EventDetailScreenController, EventDetailScreenState>(
        (ref) => EventDetailScreenController(
              eventDetailsUseCase: ref.read(eventDetailsUseCaseProvider),
              listingsUseCase: ref.read(listingsUseCaseProvider),
            ));

class EventDetailScreenController
    extends StateNotifier<EventDetailScreenState> {
  EventDetailScreenController(
      {required this.eventDetailsUseCase, required this.listingsUseCase})
      : super(EventDetailScreenState.empty());

  EventDetailsUseCase eventDetailsUseCase;
  ListingsUseCase listingsUseCase;

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
            debugPrint("Event details fold exception $l");
            state = state.copyWith(loading: false, error: l.toString());
          },
          (r) {
            var eventData = (r as GetEventDetailsResponseModel).data;
            state = state.copyWith(eventDetails: eventData, loading: false);
            print("Printing description - ${eventData?.description}");
          },
        );
      } catch (error) {
        debugPrint("Event details exception $error");
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

  Future<void> getRecommendedList() async {
    try {
      LatLong kuselLatLong = LatLong(49.53603477650214, 7.392734870386151);
      GetAllListingsRequestModel getAllListingsRequestModel =
          GetAllListingsRequestModel(
              centerLongitude: kuselLatLong.latitude,
              centerLatitude: kuselLatLong.longitude,
              radius: 20);
      GetAllListingsResponseModel getAllListingsResponseModel =
          GetAllListingsResponseModel();
      final result = await listingsUseCase.call(
          getAllListingsRequestModel, getAllListingsResponseModel);
      result.fold(
        (l) {
          state = state.copyWith( error: l.toString());
        },
        (r) {
          var listings = getSortedTop10Listings(
              (r as GetAllListingsResponseModel).data ?? []);

          final groupedEvents = <int, List<Listing>>{};

          for (final event in listings ?? []) {
            final categoryId = event.categoryId ?? 0;
            if (!groupedEvents.containsKey(categoryId)) {
              groupedEvents[categoryId] = [];
            }
            groupedEvents[categoryId]!.add(event);
          }
          state = state.copyWith(
            groupedEvents: groupedEvents,
            eventsList: listings,
            loading: false,
          );
        },
      );
    } catch (error) {
      state = state.copyWith( error: error.toString());
    }
  }

  List<Listing> getSortedTop10Listings(List<Listing> listings) {
    final now = DateTime.now();

    final filteredListings = listings.where((listing) {
      final startDate = listing.startDate != null
          ? DateTime.tryParse(listing.startDate!)
          : null;
      return startDate != null && !startDate.isBefore(now);
    }).toList();

    filteredListings.sort((a, b) {
      final aDate = DateTime.parse(a.startDate!);
      final bDate = DateTime.parse(b.startDate!);
      return aDate.compareTo(bDate);
    });

    return filteredListings.take(10).toList();
  }

  List<Listing> subList(List<Listing> list) {
    return list.length > 3 ? list.sublist(0, 3) : list;
  }
}

class EventDetailScreenParams {
  int? eventId;

  EventDetailScreenParams({required this.eventId});
}
