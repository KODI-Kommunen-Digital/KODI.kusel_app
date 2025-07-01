import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/digifit_exercise_details_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_exercise_details_response_model.dart';
import 'package:domain/usecase/digifit/digifit_exercise_details_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/refresh_token_provider.dart';
import 'digifit_exercise_details_state.dart';

final digifitExerciseDetailsControllerProvider = StateNotifierProvider
    .autoDispose<DigifitExerciseDetailsController, DigifitExerciseDetailsState>(
        (ref) => DigifitExerciseDetailsController(
            digifitExerciseDetailsUseCase:
                ref.read(digifitExerciseDetailsUseCaseProvider),
            tokenStatus: ref.read(tokenStatusProvider),
            refreshTokenProvider: ref.read(refreshTokenProvider)));

class DigifitExerciseDetailsController
    extends StateNotifier<DigifitExerciseDetailsState> {
  final DigifitExerciseDetailsUseCase digifitExerciseDetailsUseCase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;

  DigifitExerciseDetailsController(
      {required this.digifitExerciseDetailsUseCase,
      required this.tokenStatus,
      required this.refreshTokenProvider})
      : super(DigifitExerciseDetailsState.empty());

  Future<void> fetchDigifitExerciseDetails(
      int equipmentId, String location) async {
    try {
      final isTokenExpired = tokenStatus.isAccessTokenExpired();

      if (isTokenExpired) {
        await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () {
              _fetchDigifitExerciseDetails(equipmentId, location);
            });
      } else {
        // If the token is not expired, we can proceed with the request
        _fetchDigifitExerciseDetails(equipmentId, location);
      }
    } catch (e) {
      debugPrint('[DigifitExerciseDetailsController] Fetch Exception: $e');
    }
  }

  _fetchDigifitExerciseDetails(int equipmentId, String location) async {
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
        debugPrint(
            '[DigifitExerciseDetailsController] Fetch fold Error: ${l.toString()}');
      }, (r) {
        var response = (r as DigifitExerciseDetailsResponseModel).data;
        state = state.copyWith(
            isLoading: false,
            digifitExerciseRelatedEquipmentsModel: response.relatedEquipments,
            digifitExerciseEquipmentModel: response.equipment);
      });
    } catch (error) {
      debugPrint(
          '[DigifitExerciseDetailsController] Fetch fold Exception: $error');
    }
  }
}
