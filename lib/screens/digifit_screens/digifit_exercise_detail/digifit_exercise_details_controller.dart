import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/digifit_exercise_details_request_model.dart';
import 'package:domain/model/request_model/digifit/digifit_exercise_details_tracking_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_exercise_details_response_model.dart';
import 'package:domain/model/response_model/digifit/digifit_exercise_details_tracking_response_model.dart';
import 'package:domain/usecase/digifit/digifit_exercise_details_tracking_usecase.dart';
import 'package:domain/usecase/digifit/digifit_exercise_details_usecase.dart';
import 'package:domain/usecase/digifit/digifit_qr_scanner_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/providers/digifit_equipment_fav_provider.dart';

import '../../../locale/localization_manager.dart';
import '../../../providers/refresh_token_provider.dart';
import 'digifit_exercise_details_state.dart';
import 'enum/digifit_exercise_session_status_enum.dart';

final digifitExerciseDetailsControllerProvider = StateNotifierProvider
    .autoDispose<DigifitExerciseDetailsController, DigifitExerciseDetailsState>(
        (ref) => DigifitExerciseDetailsController(
              digifitExerciseDetailsUseCase:
                  ref.read(digifitExerciseDetailsUseCaseProvider),
              digifitExerciseDetailsTrackingUseCase:
                  ref.read(digifitExerciseDetailsTrackingUseCaseProvider),
              tokenStatus: ref.read(tokenStatusProvider),
              refreshTokenProvider: ref.read(refreshTokenProvider),
              localeManagerController: ref.read(localeManagerProvider.notifier),
              digifitEquipmentFav: ref.read(digifitEquipmentFavProvider),
              digifitQrScannerUseCase:
                  ref.read(digifitQrScannerUseCaseProvider),
            ));

class DigifitExerciseDetailsController
    extends StateNotifier<DigifitExerciseDetailsState> {
  final DigifitExerciseDetailsUseCase digifitExerciseDetailsUseCase;
  final DigifitExerciseDetailsTrackingUseCase
      digifitExerciseDetailsTrackingUseCase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;
  final LocaleManagerController localeManagerController;
  final DigifitEquipmentFav digifitEquipmentFav;
  final DigifitQrScannerUseCase digifitQrScannerUseCase;

  DigifitExerciseDetailsController(
      {required this.digifitExerciseDetailsUseCase,
      required this.digifitExerciseDetailsTrackingUseCase,
      required this.tokenStatus,
      required this.refreshTokenProvider,
      required this.localeManagerController,
      required this.digifitEquipmentFav,
      required this.digifitQrScannerUseCase})
      : super(DigifitExerciseDetailsState.empty());

  Future<void> fetchDigifitExerciseDetails(
      int equipmentId, int locationId) async {
    try {
      final isTokenExpired = tokenStatus.isAccessTokenExpired();

      if (isTokenExpired) {
        await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () {
              _fetchDigifitExerciseDetails(equipmentId, locationId);
            });
      } else {
        // If the token is not expired, we can proceed with the request
        _fetchDigifitExerciseDetails(equipmentId, locationId);
      }
    } catch (e) {
      debugPrint('[DigifitExerciseDetailsController] Fetch Exception: $e');
    }
  }

  _fetchDigifitExerciseDetails(int equipmentId, int locationId) async {
    try {
      state = state.copyWith(isLoading: true);

      Locale currentLocale = localeManagerController.getSelectedLocale();

      DigifitExerciseDetailsRequestModel digifitExerciseDetailsRequestModel =
          DigifitExerciseDetailsRequestModel(
              equipmentId: equipmentId,
              locationId: locationId,
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}");

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
            digifitExerciseRelatedEquipmentsModel: response.relatedStations,
            digifitExerciseEquipmentModel: response.equipment,
            totalSetNumber: response.equipment.userProgress.totalSets,
            currentSetNumber: response.equipment.userProgress.currentSet);
      });
    } catch (error) {
      debugPrint(
          '[DigifitExerciseDetailsController] Fetch fold Exception: $error');
    }
  }

  onFavTap(
      {required DigifitEquipmentFavParams digifitEquipmentFavParams,
      required Future Function(bool, DigifitEquipmentFavParams)
          onFavStatusChange}) async {
    try {
      await digifitEquipmentFav.changeEquipmentFavStatus(
          onFavStatusChange: onFavStatusChange,
          params: digifitEquipmentFavParams);
    } catch (error) {
      debugPrint('exception on fav tap : $error');
    }
  }

  Future<void> detailPageOnFavStatusChange(
      bool res, DigifitEquipmentFavParams params) async {
    try {
      DigifitExerciseEquipmentModel? model =
          state.digifitExerciseEquipmentModel;

      if (model != null) {
        model.isFavorite = res;
        state = state.copyWith(digifitExerciseEquipmentModel: model);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> recommendOnFavStatusChange(
      bool res, DigifitEquipmentFavParams params) async {
    try {
      List<DigifitExerciseRelatedStationsModel> list =
          state.digifitExerciseRelatedEquipmentsModel;

      for (DigifitExerciseRelatedStationsModel item in list) {
        if (params.equipmentId == item.id) {
          item.isFavorite = res;
          break;
        }
      }

      state = state.copyWith(digifitExerciseRelatedEquipmentsModel: list);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> validateQrScanner(String shortUrl, String equipmentSlug) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await digifitQrScannerUseCase.call(shortUrl);

      return result.fold((error) {
        debugPrint("[Validate Url Expansion] URL expansion failed: $error");
        state = state.copyWith(isLoading: false);
        return false;
      }, (expandedUrl) {
        final slugUrl = digifitQrScannerUseCase.getSlugFromUrl(expandedUrl);
        state = state.copyWith(isLoading: false);
        return slugUrl == equipmentSlug;
      });
    } catch (error) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  Future<void> trackExerciseDetails(int equipmentId, int locationId, int sets,
      int reps, ExerciseStageConstant stageConstant) async {
    try {
      final isTokenExpired = tokenStatus.isAccessTokenExpired();

      if (isTokenExpired) {
        await refreshTokenProvider.getNewToken(
          onError: () {},
          onSuccess: () async {
            await _trackExerciseDetails(
                equipmentId, locationId, sets, reps, stageConstant);
          },
        );
      } else {
        await _trackExerciseDetails(
            equipmentId, locationId, sets, reps, stageConstant);
      }
    } catch (e) {
      debugPrint('[CardExerciseDetailsController] Track Exception: $e');
    }
  }

  _trackExerciseDetails(int equipmentId, int locationId, int sets, int reps,
      ExerciseStageConstant stageConstant) async {
    try {
      state = state.copyWith(isLoading: true);

      DigifitExerciseDetailsTrackingRequestModel
          digifitExerciseDetailsTrackingRequestModel =
          DigifitExerciseDetailsTrackingRequestModel(
              equipmentId: equipmentId,
              locationId: locationId,
              setNumber: sets,
              reps: reps,
              activityStatus: stageConstant.name);

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


        DigifitExerciseEquipmentModel? digifitExerciseEquipmentModel = state.digifitExerciseEquipmentModel;
        final isComplete = response.isCompleted;


        if(digifitExerciseEquipmentModel?.userProgress.isCompleted !=null)
          {
            digifitExerciseEquipmentModel?.userProgress.isCompleted = isComplete;
          }

        state = state.copyWith(
            isLoading: false,
            currentSetNumber: response.setNumber,
        digifitExerciseEquipmentModel: digifitExerciseEquipmentModel);

      });
    } catch (error) {
      debugPrint(
          '[CardExerciseDetailsController] Fetch  Exception: $error');
    }
  }

  void updateCheckIconVisibility(bool isVisible) {
    state = state.copyWith(isCheckIconVisible: isVisible);
  }

  void updateIconBackgroundVisibility(bool iconBackgroundVisibility) {
    state = state.copyWith(isIconBackgroundVisible: iconBackgroundVisibility);
  }
}
