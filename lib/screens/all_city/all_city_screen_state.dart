import 'package:domain/model/response_model/city_details/get_city_details_response_model.dart';

class AllCityScreenState {
  List<City> cityList;
  bool isLoading;

  AllCityScreenState(this.cityList, this.isLoading);

  factory AllCityScreenState.empty() {
    return AllCityScreenState([], false);
  }

  AllCityScreenState copyWith({List<City>? cityList, bool? isLoading}) {
    return AllCityScreenState(
        cityList ?? this.cityList, isLoading ?? this.isLoading);
  }
}
