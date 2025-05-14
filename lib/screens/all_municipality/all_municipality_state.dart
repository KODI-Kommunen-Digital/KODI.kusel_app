import 'package:domain/model/response_model/municipality/municipality_response_model.dart';

class AllMunicipalityScreenState {
  List<MunicipalityCities> cityList;
  bool isLoading;

  AllMunicipalityScreenState(this.cityList, this.isLoading);

  factory AllMunicipalityScreenState.empty() {
    return AllMunicipalityScreenState([], false);
  }

  AllMunicipalityScreenState copyWith(
      {List<MunicipalityCities>? cityList, bool? isLoading}) {
    return AllMunicipalityScreenState(
        cityList ?? this.cityList, isLoading ?? this.isLoading);
  }
}
