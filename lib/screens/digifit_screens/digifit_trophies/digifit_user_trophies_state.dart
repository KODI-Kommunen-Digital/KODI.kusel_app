import 'package:domain/model/response_model/digifit/digifit_user_trophies_response_model.dart';

class DigifitUserTrophiesState {
  bool isLoading;
  final DigifitUserTrophiesResponseModel? digifitUserTrophiesResponseModel;
  final String errorMessage;

  DigifitUserTrophiesState(
      {required this.isLoading,
      required this.digifitUserTrophiesResponseModel,
      this.errorMessage = ''});

  factory DigifitUserTrophiesState.empty() {
    return DigifitUserTrophiesState(
        isLoading: false,
        digifitUserTrophiesResponseModel: null,
        errorMessage: '');
  }

  DigifitUserTrophiesState copyWith(
      {bool? isLoading,
      DigifitUserTrophiesResponseModel? digifitUserTrophiesResponseModel,
      String? errorMessage}) {
    return DigifitUserTrophiesState(
      isLoading: isLoading ?? this.isLoading,
      digifitUserTrophiesResponseModel: digifitUserTrophiesResponseModel ??
          this.digifitUserTrophiesResponseModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}