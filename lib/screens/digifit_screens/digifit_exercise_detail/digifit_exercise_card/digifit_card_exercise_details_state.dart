import 'package:domain/model/request_model/digifit/digifit_exercise_details_tracking_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_exercise_details_tracking_response_model.dart';

class DigifitCardExerciseDetailsState {
  final bool isLoading;
  final bool isCheckIconVisible;
  final bool isIconBackgroundVisible;
  final DigifitExerciseDetailsTrackingDataModel
      digifitExerciseDetailsTrackingRequestModel;
  final String errorMessage;

  DigifitCardExerciseDetailsState(
      {required this.isLoading,
      required this.isCheckIconVisible,
      required this.isIconBackgroundVisible,
      required this.errorMessage,
      required this.digifitExerciseDetailsTrackingRequestModel});

  factory DigifitCardExerciseDetailsState.initial() {
    return DigifitCardExerciseDetailsState(
      isLoading: false,
      isCheckIconVisible: false,
      isIconBackgroundVisible: false,
      digifitExerciseDetailsTrackingRequestModel:
          DigifitExerciseDetailsTrackingDataModel(),
      errorMessage: '',
    );
  }

  DigifitCardExerciseDetailsState copyWith({
    bool? isLoading,
    bool? isCheckIconVisible,
    bool? isIconBackgroundVisible,
    DigifitExerciseDetailsTrackingDataModel?
        digifitExerciseDetailsTrackingRequestModel,
    String? errorMessage,
  }) {
    return DigifitCardExerciseDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isCheckIconVisible: isCheckIconVisible ?? this.isCheckIconVisible,
      isIconBackgroundVisible:
          isIconBackgroundVisible ?? this.isIconBackgroundVisible,
      digifitExerciseDetailsTrackingRequestModel:
          digifitExerciseDetailsTrackingRequestModel ??
              this.digifitExerciseDetailsTrackingRequestModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
