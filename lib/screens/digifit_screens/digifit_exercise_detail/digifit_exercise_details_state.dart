import 'package:domain/model/response_model/digifit/digifit_exercise_details_response_model.dart';

class DigifitExerciseDetailsState {
  bool isLoading;
  final String errorMessage;
  final List<DigifitExerciseRelatedEquipmentModel> digifitExerciseRelatedEquipmentsModel;
  final DigifitExerciseEquipmentModel? digifitExerciseEquipmentModel;

  DigifitExerciseDetailsState({
    required this.isLoading,
    this.errorMessage = '',
    this.digifitExerciseRelatedEquipmentsModel = const [],
    this.digifitExerciseEquipmentModel,
  });

  factory DigifitExerciseDetailsState.empty() {
    return DigifitExerciseDetailsState(
      isLoading: false,
      errorMessage: '',
      digifitExerciseRelatedEquipmentsModel: [],
      digifitExerciseEquipmentModel: null,
    );
  }

  DigifitExerciseDetailsState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<DigifitExerciseRelatedEquipmentModel>?
        digifitExerciseRelatedEquipmentsModel,
    DigifitExerciseEquipmentModel? digifitExerciseEquipmentModel,
  }) {
    return DigifitExerciseDetailsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      digifitExerciseRelatedEquipmentsModel:
          digifitExerciseRelatedEquipmentsModel ?? this.digifitExerciseRelatedEquipmentsModel,
      digifitExerciseEquipmentModel:
          digifitExerciseEquipmentModel ?? this.digifitExerciseEquipmentModel,
    );
  }
}
