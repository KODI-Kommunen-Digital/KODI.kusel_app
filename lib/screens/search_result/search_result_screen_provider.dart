import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:data/service/location_service/location_service.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:domain/usecase/search/search_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kusel/screens/search_result/search_result_screen_parameter.dart';
import 'package:kusel/screens/search_result/search_result_screen_state.dart';

import '../../common_widgets/listing_id_enum.dart';

final searchResultScreenProvider = StateNotifierProvider.autoDispose<
        SearchResultScreenProvider, SearchResultScreenState>(
    (ref) => SearchResultScreenProvider(
        listingsUseCase: ref.read(listingsUseCaseProvider),
        searchUseCase: ref.read(searchUseCaseProvider),
        signInStatusController: ref.read(signInStatusProvider.notifier)));

class SearchResultScreenProvider
    extends StateNotifier<SearchResultScreenState> {
  SearchResultScreenProvider(
      {required this.listingsUseCase,
      required this.searchUseCase,
      required this.signInStatusController})
      : super(SearchResultScreenState.empty());
  ListingsUseCase listingsUseCase;
  SearchUseCase searchUseCase;
  SignInStatusController signInStatusController;

  Future<void> getNearbyList() async {
    try {
      state = state.copyWith(loading: true, error: "");
      GetAllListingsRequestModel getAllListingsRequestModel =
          GetAllListingsRequestModel(
              radius: SearchRadius.radius.value,
              centerLatitude: 49.53838,
              centerLongitude: 7.40647);
      GetAllListingsResponseModel getAllListingsResponseModel =
          GetAllListingsResponseModel();
      final result = await listingsUseCase.call(
          getAllListingsRequestModel, getAllListingsResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(loading: false, error: l.toString());
        },
        (r) {
          var listings = (r as GetAllListingsResponseModel).data;
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
      print("error $error");
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<Position?> getLocation() async {
    return await LocationService.getCurrentLocation();
  }

  void getEventsList(SearchType searchType) {
    if (searchType == SearchType.nearBy) {
      getNearbyList();
    } else {
      getRecommendedList();
    }
  }

  Future<void> getRecommendedList() async {
    try {
      state = state.copyWith(loading: true, error: "");
      GetAllListingsRequestModel getAllListingsRequestModel =
          GetAllListingsRequestModel();
      GetAllListingsResponseModel getAllListingsResponseModel =
          GetAllListingsResponseModel();
      final result = await listingsUseCase.call(
          getAllListingsRequestModel, getAllListingsResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(loading: false, error: l.toString());
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
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  List<Listing> getSortedTop10Listings(List<Listing> listings) {
    listings.sort((a, b) {
      final aDate =
          a.startDate != null ? DateTime.tryParse(a.startDate!) : null;
      final bDate =
          b.startDate != null ? DateTime.tryParse(b.startDate!) : null;

      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;

      return aDate.compareTo(bDate);
    });

    return listings.take(10).toList();
  }

  List<Listing> subList(List<Listing> list) {
    return list.length > 3 ? list.sublist(0, 3) : list;
  }

  isUserLoggedIn() async {
    final status = await signInStatusController.isUserLoggedIn();
    state = state.copyWith(isUserLoggedIn: status);
  }

  updateIsFav(bool isFav, int? eventId)
  {
    final list = state.eventsList;
    for (var listing in list) {
      if (listing.id == eventId) {
        listing.isFavorite = isFav;
      }
    }
    state = state.copyWith(eventsList: list);
  }
}
