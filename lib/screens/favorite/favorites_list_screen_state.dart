import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:kusel/screens/new_filter_screen/new_filter_screen_state.dart';

class FavoritesListScreenState {
  String address;
  String error;
  bool loading;
  List<Listing> eventsList;

  List<String> selectedCategoryNameList;
  int selectedCityId;
  String selectedCityName;
  double radius;
  DateTime startDate;
  DateTime endDate;
  List<int> selectedCategoryIdList;
  int numberOfFiltersApplied;

  FavoritesListScreenState(
      this.address,
      this.error,
      this.loading,
      this.eventsList,
      this.selectedCategoryNameList,
      this.selectedCityId,
      this.selectedCityName,
      this.radius,
      this.startDate,
      this.endDate,
      this.selectedCategoryIdList,
      this.numberOfFiltersApplied);

  factory FavoritesListScreenState.empty() {
    return FavoritesListScreenState(
        '', '', false, [], [], 0, '', 0, defaultDate, defaultDate, [], 0);
  }

  FavoritesListScreenState copyWith(
      {String? address,
      String? error,
      bool? loading,
      List<Listing>? list,
      List<String>? selectedCategoryNameList,
      int? selectedCityId,
      String? selectedCityName,
      double? radius,
      DateTime? startDate,
      DateTime? endDate,
      List<int>? selectedCategoryIdList,
      int? numberOfFiltersApplied}) {
    return FavoritesListScreenState(
        address ?? this.address,
        error ?? this.error,
        loading ?? this.loading,
        list ?? this.eventsList,
        selectedCategoryNameList ?? this.selectedCategoryNameList,
        selectedCityId ?? this.selectedCityId,
        selectedCityName ?? this.selectedCityName,
        radius ?? this.radius,
        startDate ?? this.startDate,
        endDate ?? this.endDate,
        selectedCategoryIdList ?? this.selectedCategoryIdList,
        numberOfFiltersApplied ?? this.numberOfFiltersApplied);
  }
}
