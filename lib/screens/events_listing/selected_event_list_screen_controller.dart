import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/common_widgets/listing_id_enum.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_parameter.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_state.dart';

final selectedEventListScreenProvider = StateNotifierProvider.autoDispose<
        SelectedEventListScreenController, SelectedEventListScreenState>(
    (ref) => SelectedEventListScreenController(
        listingsUseCase: ref.read(listingsUseCaseProvider),
        signInStatusController: ref.read(signInStatusProvider.notifier)));

class SelectedEventListScreenController
    extends StateNotifier<SelectedEventListScreenState> {
  ListingsUseCase listingsUseCase;
  SignInStatusController signInStatusController;

  SelectedEventListScreenController(
      {required this.listingsUseCase, required this.signInStatusController})
      : super(SelectedEventListScreenState.empty());

  Future<void> getEventsList(
      SelectedEventListScreenParameter? eventListScreenParameter) async {
    try {
      state = state.copyWith(loading: true, error: "");

      GetAllListingsRequestModel getAllListingsRequestModel =
          GetAllListingsRequestModel();
      if (eventListScreenParameter?.categoryId != null) {
        getAllListingsRequestModel.categoryId =
            eventListScreenParameter?.categoryId.toString();
      }

      if (eventListScreenParameter?.cityId != null) {
        getAllListingsRequestModel.cityId =
            eventListScreenParameter!.cityId!.toString();
      }

      if (eventListScreenParameter?.centerLatitude != null) {
        getAllListingsRequestModel.centerLatitude =
            eventListScreenParameter!.centerLatitude;
      }

      if (eventListScreenParameter?.centerLongitude != null) {
        getAllListingsRequestModel.centerLongitude =
            eventListScreenParameter!.centerLongitude;

        getAllListingsRequestModel.radius = SearchRadius.radius.value;
      }

      GetAllListingsResponseModel getAllListResponseModel =
          GetAllListingsResponseModel();

      final result = await listingsUseCase.call(
          getAllListingsRequestModel, getAllListResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(loading: false, error: l.toString());
        },
        (r) {
          var eventsList = (r as GetAllListingsResponseModel).data;
          state = state.copyWith(
              list: eventsList,
              loading: false,
              heading: eventListScreenParameter?.listHeading);
        },
      );
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  void setIsFavorite(bool isFavorite, int? id) {
    for (var listing in state.eventsList) {
      if (listing.id == id) {
        listing.isFavorite = isFavorite;
      }
    }
    state = state.copyWith(list: state.eventsList);
  }

  isUserLoggedIn() async {
    final status = await signInStatusController.isUserLoggedIn();
    state = state.copyWith(isUserLoggedIn: status);
  }

  updateIsFav(bool isFav, int? eventId) {
    final list = state.eventsList;
    for (var listing in list) {
      if (listing.id == eventId) {
        listing.isFavorite = isFav;
      }
    }
    state = state.copyWith(list: list);
  }
}
