import 'package:domain/model/response_model/ort_detail/ort_detail_response_model.dart';

class OrtDetailScreenState {
  OrtDetailDataModel? ortDetailDataModel;
  bool isLoading;
  bool isUserLoggedIn;

  OrtDetailScreenState(
      this.ortDetailDataModel, this.isLoading, this.isUserLoggedIn);

  factory OrtDetailScreenState.copyWith() {
    return OrtDetailScreenState(null, false, false);
  }

  OrtDetailScreenState copyWith(
      {OrtDetailDataModel? ortDetailDataModel,
      bool? isLoading,
      bool? isUserLoggedIn}) {
    return OrtDetailScreenState(ortDetailDataModel ?? this.ortDetailDataModel,
        isLoading ?? this.isLoading, isUserLoggedIn ?? this.isUserLoggedIn);
  }
}
