import 'package:domain/model/response_model/digifit/digifit_cache_data_response_model.dart';

class DigifitCacheDataState {
  bool isCacheDataAvailable;
  bool isLoading;
  DigifitCacheDataResponseModel? digifitCacheDataResponseModel;
  String errorMessage;

  DigifitCacheDataState(this.isCacheDataAvailable, this.isLoading,
      this.digifitCacheDataResponseModel, this.errorMessage);

  factory DigifitCacheDataState.empty() {
    return DigifitCacheDataState(false, false, null, '');
  }

  DigifitCacheDataState copyWith(
      {bool? isCacheDataAvailable,
      bool? isLoading,
      DigifitCacheDataResponseModel? digifitCacheDataResponseModel,
      String? errorMessage}) {
    return DigifitCacheDataState(
        isCacheDataAvailable ?? this.isCacheDataAvailable,
        isLoading ?? this.isLoading,
        digifitCacheDataResponseModel ?? this.digifitCacheDataResponseModel,
        errorMessage ?? this.errorMessage);
  }
}
