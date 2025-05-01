import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_parameter.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_state.dart';

final selectedEventListScreenProvider = StateNotifierProvider.autoDispose<
    SelectedEventListScreenController,
    SelectedEventListScreenState>(
        (ref) =>
        SelectedEventListScreenController(
            listingsUseCase: ref.read(listingsUseCaseProvider)));

class SelectedEventListScreenController extends StateNotifier<SelectedEventListScreenState> {
  SelectedEventListScreenController({required this.listingsUseCase})
      : super(SelectedEventListScreenState.empty());
  ListingsUseCase listingsUseCase;

  Future<void> getEventsList(
      SelectedEventListScreenParameter? eventListScreenParameter) async {
    try {
      state = state.copyWith(loading: true, error: "");

      GetAllListingsRequestModel getAllListingsRequestModel =(eventListScreenParameter?.categoryId!=null)?
      GetAllListingsRequestModel(
        categoryId: eventListScreenParameter?.categoryId.toString(),
        subcategoryId: eventListScreenParameter?.subCategoryId?.toString(),
      ):GetAllListingsRequestModel();
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

  void setIsFavorite(bool isFavorite, int? id) {

    for (var listing in state.eventsList) {
      if (listing.id == id) {
        listing.isFavorite = isFavorite;
      }
    }
    state = state.copyWith(
        list: state.eventsList);
  }

}
