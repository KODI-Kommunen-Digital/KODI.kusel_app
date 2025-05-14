import 'package:domain/model/response_model/ort_detail/ort_detail_response_model.dart';

class OrtDetailScreenState {
  OrtDetailDataModel? ortDetailDataModel;
  bool isLoading;

  OrtDetailScreenState(this.ortDetailDataModel, this.isLoading);

  factory OrtDetailScreenState.copyWith() {
    return OrtDetailScreenState(null, false);
  }

  OrtDetailScreenState copyWith(
      {OrtDetailDataModel? ortDetailDataModel, bool? isLoading}) {
    return OrtDetailScreenState(ortDetailDataModel ?? this.ortDetailDataModel,
        isLoading ?? this.isLoading);
  }
}
