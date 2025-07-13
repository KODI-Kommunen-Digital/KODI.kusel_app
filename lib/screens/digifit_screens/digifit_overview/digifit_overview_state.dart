import 'package:domain/model/response_model/digifit/digifit_overview_response_model.dart';

class DigifitOverviewState {
  bool isLoading;
  final String errorMessage;
  final DigifitOverviewDataModel? digifitOverviewDataModel;
  final bool isNetworkAvailable;

  DigifitOverviewState(
      {required this.isLoading,
      required this.errorMessage,
      this.digifitOverviewDataModel,
      required this.isNetworkAvailable});

  factory DigifitOverviewState.empty() {
    return DigifitOverviewState(
        isLoading: false,
        errorMessage: '',
        digifitOverviewDataModel: null,
        isNetworkAvailable: true);
  }

  DigifitOverviewState copyWith(
      {bool? isLoading,
      String? errorMessage,
      DigifitOverviewDataModel? digifitOverviewDataModel,
      bool? isNetworkAvailable}) {
    return DigifitOverviewState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        digifitOverviewDataModel:
            digifitOverviewDataModel ?? this.digifitOverviewDataModel,
        isNetworkAvailable: isNetworkAvailable ?? this.isNetworkAvailable);
  }
}
