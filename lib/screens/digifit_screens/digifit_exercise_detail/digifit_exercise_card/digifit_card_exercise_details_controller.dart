import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/digifit_exercise_details_tracking_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_exercise_details_tracking_response_model.dart';
import 'package:domain/usecase/digifit/digifit_exercise_details_tracking_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/refresh_token_provider.dart';
import 'digifit_card_exercise_details_state.dart';

final digifitCardExerciseDetailsControllerProvider =
    StateNotifierProvider.autoDispose<CardExerciseDetailsController,
        DigifitCardExerciseDetailsState>(
  (ref) => CardExerciseDetailsController(
    ref: ref,
    digifitExerciseDetailsTrackingUseCase:
        ref.read(digifitExerciseDetailsTrackingUseCaseProvider),
    tokenStatus: ref.read(tokenStatusProvider),
    refreshTokenProvider: ref.read(refreshTokenProvider),
  ),
);

class CardExerciseDetailsController
    extends StateNotifier<DigifitCardExerciseDetailsState> {
  final Ref ref;
  final DigifitExerciseDetailsTrackingUseCase
      digifitExerciseDetailsTrackingUseCase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;

  CardExerciseDetailsController(
      {required this.ref,
      required this.digifitExerciseDetailsTrackingUseCase,
      required this.tokenStatus,
      required this.refreshTokenProvider})
      : super(DigifitCardExerciseDetailsState.initial());

  Future<void> trackExerciseDetails(
      int equipmentId, int locationId, int sets, int reps) async {
    try {
      final isTokenExpired = tokenStatus.isAccessTokenExpired();

      if (isTokenExpired) {
        await refreshTokenProvider.getNewToken(
          onError: () {},
          onSuccess: () async {
            await _trackExerciseDetails(equipmentId, locationId, sets, reps);
          },
        );
      } else {
        await _trackExerciseDetails(equipmentId, locationId, sets, reps);
      }
    } catch (e) {
      debugPrint('[CardExerciseDetailsController] Track Exception: $e');
    }
  }

  _trackExerciseDetails(
      int equipmentId, int locationId, int sets, int reps) async {
    try {
      state = state.copyWith(isLoading: true);

      DigifitExerciseDetailsTrackingRequestModel
          digifitExerciseDetailsTrackingRequestModel =
          DigifitExerciseDetailsTrackingRequestModel(
        equipmentId: equipmentId,
        locationId: locationId,
        setNumber: sets,
        reps: reps,
      );

      DigifitExerciseDetailsTrackingResponseModel
          digifitExerciseDetailsTrackingResponseModel =
          DigifitExerciseDetailsTrackingResponseModel();

      final result = await digifitExerciseDetailsTrackingUseCase.call(
          digifitExerciseDetailsTrackingRequestModel,
          digifitExerciseDetailsTrackingResponseModel);

      result.fold((l) {
        state = state.copyWith(isLoading: false, errorMessage: l.toString());
        debugPrint(
            '[CardExerciseDetailsController] Fetch fold Error: ${l.toString()}');
      }, (r) {
        var response = (r as DigifitExerciseDetailsTrackingResponseModel).data;
        state = state.copyWith(
            isLoading: false,
            digifitExerciseDetailsTrackingRequestModel: response);
      });
    } catch (error) {
      debugPrint(
          '[CardExerciseDetailsController] Fetch fold Exception: $error');
    }
  }

  void updateCheckIconVisibility(bool isVisible) {
    state = state.copyWith(isCheckIconVisible: isVisible);
  }

  void updateIconBackgroundVisibility(bool iconBackgroundVisibility) {
    state = state.copyWith(isIconBackgroundVisible: iconBackgroundVisibility);
  }
}
