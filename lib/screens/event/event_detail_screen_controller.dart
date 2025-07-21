import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/event_details/event_details_request_model.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/response_model/event_details/event_details_response_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/usecase/event_details/event_details_usecase.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/screens/event/event_detail_screen_state.dart';

import '../../common_widgets/location_const.dart';

final eventDetailScreenProvider = StateNotifierProvider.family
    .autoDispose<EventDetailScreenController, EventDetailScreenState, int>(
        (ref, eventId) => EventDetailScreenController(
            eventDetailsUseCase: ref.read(eventDetailsUseCaseProvider),
            listingsUseCase: ref.read(listingsUseCaseProvider),
            localeManagerController: ref.read(localeManagerProvider.notifier),
            sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
            signInStatusController: ref.read(signInStatusProvider.notifier),
            tokenStatus: ref.read(tokenStatusProvider),
            refreshTokenUseCase: ref.read(refreshTokenUseCaseProvider),
            eventId: eventId));

class EventDetailScreenController
    extends StateNotifier<EventDetailScreenState> {
  final int eventId;

  EventDetailScreenController(
      {required this.eventDetailsUseCase,
      required this.listingsUseCase,
      required this.localeManagerController,
      required this.sharedPreferenceHelper,
      required this.signInStatusController,
      required this.tokenStatus,
      required this.refreshTokenUseCase,
      required this.eventId})
      : super(EventDetailScreenState.empty());

  EventDetailsUseCase eventDetailsUseCase;
  ListingsUseCase listingsUseCase;
  LocaleManagerController localeManagerController;
  SharedPreferenceHelper sharedPreferenceHelper;
  SignInStatusController signInStatusController;
  TokenStatus tokenStatus;
  RefreshTokenUseCase refreshTokenUseCase;



  Future<void> getEventDetails(int? eventId) async {
    state = state.copyWith(loading: true);
    final status = await signInStatusController.isUserLoggedIn();
    final response = tokenStatus.isAccessTokenExpired();
    if (response && status) {
      final userId = sharedPreferenceHelper.getInt(userIdKey);
      RefreshTokenRequestModel requestModel =
          RefreshTokenRequestModel(userId: userId?.toString() ?? "");
      RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();

      final refreshResponse =
          await refreshTokenUseCase.call(requestModel, responseModel);

      bool refreshSuccess = await refreshResponse.fold(
        (left) {
          debugPrint(
              'refresh token municipality detail fold exception : $left');
          return false;
        },
        (right) async {
          final res = right as RefreshTokenResponseModel;
          sharedPreferenceHelper.setString(
              tokenKey, res.data?.accessToken ?? "");
          sharedPreferenceHelper.setString(
              refreshTokenKey, res.data?.refreshToken ?? "");
          return true;
        },
      );

      if (!refreshSuccess) {
        state = state.copyWith(loading: false);
        return;
      }
    }
    if (eventId != null) {
      try {
        state = state.copyWith(loading: true, error: "");

        Locale currentLocale = localeManagerController.getSelectedLocale();

        GetEventDetailsRequestModel getEventDetailsRequestModel =
            GetEventDetailsRequestModel(
                id: eventId,
                translate:
                    "${currentLocale.languageCode}-${currentLocale.countryCode}");

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
            state = state.copyWith(
                eventDetails: eventData,
                loading: false,
                isFavourite: eventData?.isFavorite ?? false);
            debugPrint("Printing isFav - ${eventData?.description}");
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
      Locale currentLocale = localeManagerController.getSelectedLocale();

      GetAllListingsRequestModel getAllListingsRequestModel =
          GetAllListingsRequestModel(
              centerLongitude: EventLatLong.kusel.longitude,
              centerLatitude: EventLatLong.kusel.latitude,
              radius: 20,
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}");
      GetAllListingsResponseModel getAllListingsResponseModel =
          GetAllListingsResponseModel();
      final result = await listingsUseCase.call(
          getAllListingsRequestModel, getAllListingsResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(error: l.toString());
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
      if(mounted){
        state = state.copyWith(error: error.toString());
      }
    }
  }

  assignIsFav(bool isFav) {
    state = state.copyWith(isFavourite: isFav);
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

  void toggleFav() {
    bool isFav = state.isFavourite;
    state = state.copyWith(isFavourite: isFav ? false : true);
  }
}

class EventDetailScreenParams {
  Listing? event;
  Function()? onFavClick;

  EventDetailScreenParams({required this.event, this.onFavClick});
}
