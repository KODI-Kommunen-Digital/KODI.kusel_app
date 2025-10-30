import 'package:domain/model/response_model/explore_details/explore_details_response_model.dart';
import 'package:domain/model/response_model/filter/get_filter_response_model.dart';

final defaultDate = DateTime(1990);


class NewFilterScreenState {
  List<FilterItem> cityList;
  int selectedCityId;
  String selectedCityName;
  double sliderValue;
  bool isLoading;
  List<FilterItem> categoryList;
  List<String> selectedCategoryName;
  DateTime startDate;
  DateTime endDate;
  List<int> selectedCategoryId;



  NewFilterScreenState(
      this.cityList,
      this.selectedCityId,
      this.sliderValue,
      this.selectedCityName,
      this.isLoading,
      this.categoryList,
      this.selectedCategoryName,
      this.startDate,
      this.endDate,
      this.selectedCategoryId);

  factory NewFilterScreenState.empty() {
    return NewFilterScreenState([], 0, 0, "", false, [], [], defaultDate, defaultDate,[]);
  }

  NewFilterScreenState copyWith(
      {List<FilterItem>? cityList,
      int? selectedCityId,
      double? sliderValue,
      String? selectedCityName,
      bool? isLoading,
      List<FilterItem>? categoryList,
      List<String>? selectedCategoryName,
      DateTime? startDate,
      DateTime? endDate,
      List<int>? selectedCategoryId}) {
    return NewFilterScreenState(
        cityList ?? this.cityList,
        selectedCityId ?? this.selectedCityId,
        sliderValue ?? this.sliderValue,
        selectedCityName ?? this.selectedCityName,
        isLoading ?? this.isLoading,
        categoryList ?? this.categoryList,
        selectedCategoryName ?? this.selectedCategoryName,
        startDate ?? this.startDate,
        endDate ?? this.endDate,
    selectedCategoryId??this.selectedCategoryId);
  }
}
