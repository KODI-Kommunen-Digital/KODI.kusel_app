import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';
import 'package:flutter/cupertino.dart';

class DigifitState {
  bool isLoading;
  final DigifitInformationDataModel? digifitInformationDataModel;
  final String errorMessage;
  final bool isNetworkAvailable;

  DigifitState(
      {required this.isLoading,
      required this.digifitInformationDataModel,
      this.errorMessage = '',
      required this.isNetworkAvailable});

  factory DigifitState.empty() {
    return DigifitState(
        isLoading: false,
        digifitInformationDataModel: null,
        errorMessage: '',
        isNetworkAvailable: true);
  }

  DigifitState copyWith(
      {bool? isLoading,
      DigifitInformationDataModel? digifitInformationDataModel,
      String? errorMessage,
      bool? isNetworkAvailable}) {
    return DigifitState(
        isLoading: isLoading ?? this.isLoading,
        digifitInformationDataModel:
            digifitInformationDataModel ?? this.digifitInformationDataModel,
        errorMessage: errorMessage ?? this.errorMessage,
        isNetworkAvailable: isNetworkAvailable ?? this.isNetworkAvailable);
  }
}
