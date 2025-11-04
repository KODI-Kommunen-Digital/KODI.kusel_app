import 'package:domain/model/response_model/digifit/digifit_fav_response_model.dart';

class DigifitFavScreenState {
  bool isLoading;
  List<DigifitFavData> equipmentList;

  DigifitFavScreenState(this.isLoading, this.equipmentList);

  factory DigifitFavScreenState.empty() {
    return DigifitFavScreenState(true, []);
  }

  DigifitFavScreenState copyWith(
      {bool? isLoading, List<DigifitFavData>? equipmentList}) {
    return DigifitFavScreenState(
        isLoading ?? this.isLoading, equipmentList ?? this.equipmentList);
  }
}
