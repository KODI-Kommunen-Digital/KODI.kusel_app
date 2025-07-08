import 'package:domain/model/response_model/digifit/digifit_exercise_details_response_model.dart';
import 'package:domain/model/response_model/digifit/digifit_exercise_details_tracking_response_model.dart';

class DigifitExerciseDetailsState {
  bool isLoading;
  final String errorMessage;
  final List<DigifitExerciseRelatedStationsModel>
      digifitExerciseRelatedEquipmentsModel;
  final DigifitExerciseEquipmentModel? digifitExerciseEquipmentModel;
  final bool isCheckIconVisible;
  final bool isIconBackgroundVisible;
  final int currentSetNumber;
  final int totalSetNumber;


  DigifitExerciseDetailsState(
      {required this.isLoading,
      this.errorMessage = '',
      this.digifitExerciseRelatedEquipmentsModel = const [],
      this.digifitExerciseEquipmentModel,
      required this.isCheckIconVisible,
      required this.isIconBackgroundVisible,
      required this.currentSetNumber,
      required this.totalSetNumber});

  factory DigifitExerciseDetailsState.empty() {
    return DigifitExerciseDetailsState(
        isLoading: false,
        errorMessage: '',
        digifitExerciseRelatedEquipmentsModel: [],
        digifitExerciseEquipmentModel: null,
        isCheckIconVisible: false,
        isIconBackgroundVisible: false,
        currentSetNumber: 0,
        totalSetNumber: 0);
  }

  DigifitExerciseDetailsState copyWith(
      {bool? isLoading,
      String? errorMessage,
      List<DigifitExerciseRelatedStationsModel>?
          digifitExerciseRelatedEquipmentsModel,
      DigifitExerciseEquipmentModel? digifitExerciseEquipmentModel,
      bool? isCheckIconVisible,
      bool? isIconBackgroundVisible,
      int? currentSetNumber,
      int? totalSetNumber}) {
    return DigifitExerciseDetailsState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        digifitExerciseRelatedEquipmentsModel:
            digifitExerciseRelatedEquipmentsModel ??
                this.digifitExerciseRelatedEquipmentsModel,
        digifitExerciseEquipmentModel:
            digifitExerciseEquipmentModel ?? this.digifitExerciseEquipmentModel,
        isCheckIconVisible: isCheckIconVisible ?? this.isCheckIconVisible,
        isIconBackgroundVisible:
            isIconBackgroundVisible ?? this.isIconBackgroundVisible,
        currentSetNumber: currentSetNumber ?? this.currentSetNumber,
        totalSetNumber: totalSetNumber ?? this.totalSetNumber);
  }
}
