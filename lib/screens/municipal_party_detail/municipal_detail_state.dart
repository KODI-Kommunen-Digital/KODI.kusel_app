import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/municipal_party_detail/municipal_party_detail_response_model.dart';

class MunicipalDetailState {
  List<Listing> eventList;
  List<Listing> newsList;
  bool showEventLoading;
  bool showNewsLoading;
  bool isLoading;
  MunicipalPartyDetailDataModel? municipalPartyDetailDataModel;

  MunicipalDetailState(this.eventList, this.newsList, this.showEventLoading,
      this.showNewsLoading, this.isLoading, this.municipalPartyDetailDataModel);

  factory MunicipalDetailState.empty() {
    return MunicipalDetailState([], [], false, false, false, null);
  }

  MunicipalDetailState copyWith(
      {List<Listing>? eventList,
      List<Listing>? newsList,
      bool? showEventLoading,
      bool? showNewsLoading,
      bool? isLoading,
      MunicipalPartyDetailDataModel? municipalPartyDetailDataModel}) {
    return MunicipalDetailState(
        eventList ?? this.eventList,
        newsList ?? this.newsList,
        showEventLoading ?? this.showEventLoading,
        showNewsLoading ?? this.showNewsLoading,
        isLoading ?? this.isLoading,
        municipalPartyDetailDataModel ?? this.municipalPartyDetailDataModel);
  }
}
