import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/events_listing/event_list_screen_parameter.dart';
import 'package:kusel/screens/events_listing/event_list_screen_state.dart';

final eventListScreenProvider = StateNotifierProvider.autoDispose<
    EventListScreenController,
    EventListScreenState>(
        (ref) =>
        EventListScreenController(
            listingsUseCase: ref.read(listingsUseCaseProvider)));

class EventListScreenController extends StateNotifier<EventListScreenState> {
  EventListScreenController({required this.listingsUseCase})
      : super(EventListScreenState.empty());
  ListingsUseCase listingsUseCase;

  Future<void> getEventsList(
      EventListScreenParameter? eventListScreenParameter) async {
    try {
      state = state.copyWith(loading: true, error: "");

      GetAllListingsRequestModel getAllListingsRequestModel =
      GetAllListingsRequestModel(
        radius: eventListScreenParameter?.radius,
        centerLatitude: eventListScreenParameter?.centerLongitude,
        centerLongitude: eventListScreenParameter?.centerLatitude,
        categoryId: eventListScreenParameter?.categoryId.toString(),
        subcategoryId: eventListScreenParameter?.subCategoryId?.toString(),
      );
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
          state = state.copyWith(list: eventsList, loading: false);
        },
      );
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }
}
