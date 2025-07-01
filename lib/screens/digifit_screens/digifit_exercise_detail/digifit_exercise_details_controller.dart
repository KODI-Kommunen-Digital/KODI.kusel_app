import 'package:domain/model/request_model/digifit/digifit_exercise_details_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_exercise_details_response_model.dart';
import 'package:domain/usecase/digifit/digifit_exercise_details_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'digifit_exercise_details_state.dart';

final digifitExerciseDetailsControllerProvider = StateNotifierProvider
    .autoDispose<DigifitExerciseDetailsController, DigifitExerciseDetailsState>(
        (ref) => DigifitExerciseDetailsController(
              digifitExerciseDetailsUseCase:
                  ref.read(digifitExerciseDetailsUseCaseProvider),
            ));

class DigifitExerciseDetailsController
    extends StateNotifier<DigifitExerciseDetailsState> {
  final DigifitExerciseDetailsUseCase digifitExerciseDetailsUseCase;

  DigifitExerciseDetailsController(
      {required this.digifitExerciseDetailsUseCase})
      : super(DigifitExerciseDetailsState.empty());

  Future<void> fetchDigifitExerciseDetails(
      int equipmentId, String location) async {
    try {
      state = state.copyWith(isLoading: true);

      DigifitExerciseDetailsRequestModel digifitExerciseDetailsRequestModel =
          DigifitExerciseDetailsRequestModel(
              equipmentId: equipmentId, location: location);

      DigifitExerciseDetailsResponseModel digifitExerciseDetailsResponseModel =
          DigifitExerciseDetailsResponseModel();

      final result = await digifitExerciseDetailsUseCase.call(
          digifitExerciseDetailsRequestModel,
          digifitExerciseDetailsResponseModel);

      result.fold((l) {
        state = state.copyWith(isLoading: false, errorMessage: l.toString());
      }, (r) {
        var response = (r as DigifitExerciseDetailsResponseModel).data;
        state = state.copyWith(
            isLoading: false,
            digifitExerciseRelatedEquipmentsModel: response.relatedEquipments,
            digifitExerciseEquipmentModel: response.equipment);
      });
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }
}
