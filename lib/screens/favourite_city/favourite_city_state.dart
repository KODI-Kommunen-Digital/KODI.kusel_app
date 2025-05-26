import 'package:domain/model/response_model/favourite_city/favourite_city_response_model.dart';

class FavouriteCityScreenState {
  List<CityModel> cityList;
  bool isLoading;

  FavouriteCityScreenState(this.cityList, this.isLoading);

  factory FavouriteCityScreenState.empty() {
    return FavouriteCityScreenState([], false);
  }

  FavouriteCityScreenState copyWith({List<CityModel>? cityList, bool? isLoading}) {
    return FavouriteCityScreenState(
        cityList ?? this.cityList, isLoading ?? this.isLoading);
  }
}
