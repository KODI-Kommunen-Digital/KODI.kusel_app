import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/digifit_overview_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_overview_response_model.dart';
import 'package:domain/usecase/digifit/digifit_overview_usecase.dart';
import 'package:domain/usecase/digifit/digifit_qr_scanner_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widgets/get_slug.dart';
import '../../../locale/localization_manager.dart';
import '../../../providers/digifit_equipment_fav_provider.dart';
import '../../../providers/refresh_token_provider.dart';
import 'digifit_overview_state.dart';

final digifitOverviewScreenControllerProvider = StateNotifierProvider
    .autoDispose<DigifitOverviewController, DigifitOverviewState>((ref) =>
        DigifitOverviewController(
            digifitOverviewUseCase: ref.read(digifitOverviewUseCaseProvider),
            tokenStatus: ref.read(tokenStatusProvider),
            refreshTokenProvider: ref.read(refreshTokenProvider),
            localeManagerController: ref.read(localeManagerProvider.notifier),
            digifitEquipmentFav: ref.read(digifitEquipmentFavProvider),
            digifitQrScannerUseCase: ref.read(digifitQrScannerUseCaseProvider),
            signInStatusController: ref.read(signInStatusProvider.notifier)));

class DigifitOverviewController extends StateNotifier<DigifitOverviewState> {
  final DigifitOverviewUseCase digifitOverviewUseCase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;
  final LocaleManagerController localeManagerController;
  final DigifitEquipmentFav digifitEquipmentFav;
  final DigifitQrScannerUseCase digifitQrScannerUseCase;
  final SignInStatusController signInStatusController;

  DigifitOverviewController(
      {required this.digifitOverviewUseCase,
      required this.tokenStatus,
      required this.refreshTokenProvider,
      required this.localeManagerController,
      required this.digifitEquipmentFav,
      required this.digifitQrScannerUseCase,
      required this.signInStatusController})
      : super(DigifitOverviewState.empty());

  Future<void> fetchDigifitOverview(int locationId) async {
    try {
      state = state.copyWith(isLoading: true);

      final isTokenExpired = tokenStatus.isDigifitAccessTokenExpired();
      final status = await signInStatusController.isUserLoggedIn();

      if (isTokenExpired && status) {
        await refreshTokenProvider.getDigifitNewToken(
            onError: () {},
            onSuccess: () {
              _fetchDigifitOverview(locationId);
            });
      } else {
        // If the token is not expired, we can proceed with the request
        _fetchDigifitOverview(locationId);
      }
    } catch (e) {
      debugPrint('[DigifitOverviewController] Fetch Exception');
    }
  }

  _fetchDigifitOverview(int locationId) async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();

      DigifitOverviewRequestModel digifitOverviewRequestModel =
          DigifitOverviewRequestModel(
              locationId: locationId,
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}");

      DigifitOverviewResponseModel digifitOverviewResponseModel =
          DigifitOverviewResponseModel();

      final result = await digifitOverviewUseCase.call(
          digifitOverviewRequestModel, digifitOverviewResponseModel);

      result.fold(
        (l) {
          state = state.copyWith(isLoading: false, errorMessage: l.toString());
          debugPrint(
              '[DigifitOverviewController] Fetch fold Error: ${l.toString()}');
        },
        (r) {
          var response = (r as DigifitOverviewResponseModel).data;
          state = state.copyWith(
              isLoading: false, digifitOverviewDataModel: response);
        },
      );
    } catch (error) {
      debugPrint('[DigifitOverviewController] Fetch fold Exception: $error');
    }
  }

  availableStationOnFavTap({
    required DigifitEquipmentFavParams digifitEquipmentFavParams,
  }) async {
    try {
      await digifitEquipmentFav.changeEquipmentFavStatus(
          onFavStatusChange: _availableStationOnFavStatusChange,
          params: digifitEquipmentFavParams);
    } catch (error) {
      debugPrint('exception availableStationOnFavTap : $error');
    }
  }

  Future<void> _availableStationOnFavStatusChange(
    bool value,
    DigifitEquipmentFavParams params,
  ) async {
    try {
      List<DigifitOverviewStationModel> stationList =
          state.digifitOverviewDataModel?.parcours?.availableStation ?? [];

      for (DigifitOverviewStationModel digifitOverviewStationModel
          in stationList) {
        if (digifitOverviewStationModel.id != null &&
            digifitOverviewStationModel.id == params.equipmentId) {
          digifitOverviewStationModel.isFavorite = value;
          break;
        }
      }

      state.digifitOverviewDataModel!.parcours!.availableStation = stationList;
      state = state.copyWith(
          digifitOverviewDataModel: state.digifitOverviewDataModel);
    } catch (error) {
      rethrow;
    }
  }

  completedStationOnFavTap({
    required DigifitEquipmentFavParams digifitEquipmentFavParams,
  }) async {
    try {
      await digifitEquipmentFav.changeEquipmentFavStatus(
          onFavStatusChange: _completedStationOnFavStatusChange,
          params: digifitEquipmentFavParams);
    } catch (error) {
      debugPrint('exception availableStationOnFavTap : $error');
    }
  }

  Future<void> _completedStationOnFavStatusChange(
    bool value,
    DigifitEquipmentFavParams params,
  ) async {
    try {
      List<DigifitOverviewStationModel> stationList =
          state.digifitOverviewDataModel?.parcours?.availableStation ?? [];

      for (DigifitOverviewStationModel digifitOverviewStationModel
          in stationList) {
        if (digifitOverviewStationModel.id != null &&
            digifitOverviewStationModel.id == params.equipmentId) {
          digifitOverviewStationModel.isFavorite = value;
          break;
        }
      }

      state.digifitOverviewDataModel!.parcours!.availableStation = stationList;
      state = state.copyWith(
          digifitOverviewDataModel: state.digifitOverviewDataModel);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getSlug(
      String shortUrl, Function(String) onSuccess, VoidCallback onError) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await digifitQrScannerUseCase.call(shortUrl);

      return result.fold((error) {
        debugPrint("get slug fold exception: $error");
        state = state.copyWith(isLoading: false);
        onError();
      }, (expandedUrl) {
        final slugUrl = getSlugFromUrl(expandedUrl);
        debugPrint('extracted slug : $slugUrl');
        state = state.copyWith(isLoading: false);
        onSuccess(slugUrl);
      });
    } catch (error) {
      onError();
      debugPrint("get slug exception: $error");
      state = state.copyWith(isLoading: false);
    }
  }
}
