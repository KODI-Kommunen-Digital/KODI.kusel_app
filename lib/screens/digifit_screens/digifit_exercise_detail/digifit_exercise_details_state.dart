import 'package:domain/model/response_model/digifit/digifit_exercise_details_response_model.dart';

class DigifitExerciseDetailsState {
  bool isLoading;
  final String errorMessage;
  final List<DigifitExerciseRelatedStationsModel>
      digifitExerciseRelatedEquipmentsModel;
  final DigifitExerciseEquipmentModel? digifitExerciseEquipmentModel;
  final bool isReadyToSubmitSet;
  final int currentSetNumber;
  final int totalSetNumber;
  final bool isScannerVisible;
  final int locationId;

  DigifitExerciseDetailsState(
      {required this.isLoading,
      this.errorMessage = '',
      this.digifitExerciseRelatedEquipmentsModel = const [],
      this.digifitExerciseEquipmentModel,
      required this.isReadyToSubmitSet,
      required this.currentSetNumber,
      required this.totalSetNumber,
      required this.isScannerVisible,
      required this.locationId});

  factory DigifitExerciseDetailsState.empty() {
    return DigifitExerciseDetailsState(
        isLoading: false,
        errorMessage: '',
        digifitExerciseRelatedEquipmentsModel: [],
        digifitExerciseEquipmentModel: null,
        isReadyToSubmitSet: false,
        currentSetNumber: 0,
        totalSetNumber: 0,
        isScannerVisible: true,
        locationId: 0);
  }

  DigifitExerciseDetailsState copyWith(
      {bool? isLoading,
      String? errorMessage,
      List<DigifitExerciseRelatedStationsModel>?
          digifitExerciseRelatedEquipmentsModel,
      DigifitExerciseEquipmentModel? digifitExerciseEquipmentModel,
      bool? isReadyToSubmitSet,
      int? currentSetNumber,
      int? totalSetNumber,
      bool? isScannerVisible,
      int? locationId}) {
    return DigifitExerciseDetailsState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        digifitExerciseRelatedEquipmentsModel:
            digifitExerciseRelatedEquipmentsModel ??
                this.digifitExerciseRelatedEquipmentsModel,
        digifitExerciseEquipmentModel:
            digifitExerciseEquipmentModel ?? this.digifitExerciseEquipmentModel,
        isReadyToSubmitSet: isReadyToSubmitSet ?? this.isReadyToSubmitSet,
        currentSetNumber: currentSetNumber ?? this.currentSetNumber,
        totalSetNumber: totalSetNumber ?? this.totalSetNumber,
        isScannerVisible: isScannerVisible ?? this.isScannerVisible,
        locationId: locationId ?? this.locationId);
  }
}
