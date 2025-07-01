import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';

class DigitfitState {
  bool isLoading;
  final DigifitInformationDataModel? digifitInformationDataModel;
  final String errorMessage;

  DigitfitState(
      {required this.isLoading,
      required this.digifitInformationDataModel,
      this.errorMessage = ''});

  factory DigitfitState.empty() {
    return DigitfitState(
        isLoading: false, digifitInformationDataModel: null, errorMessage: '');
  }

  DigitfitState copyWith(
      {bool? isLoading,
      DigifitInformationDataModel? digifitInformationDataModel,
      String? errorMessage}) {
    return DigitfitState(
      isLoading: isLoading ?? this.isLoading,
      digifitInformationDataModel:
          digifitInformationDataModel ?? this.digifitInformationDataModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
