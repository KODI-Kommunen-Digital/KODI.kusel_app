import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/digifit_user_trophies_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_user_trophies_response_model.dart';
import 'package:domain/usecase/digifit/digifit_user_trophies_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/screens/digifit_screens/digifit_trophies/digifit_user_trophies_state.dart';

import '../../../providers/digifit_equipment_fav_provider.dart';
import '../../../providers/refresh_token_provider.dart';

final digifitUserTrophiesControllerProvider = StateNotifierProvider.autoDispose<
    DigifitUserTrophiesController, DigifitUserTrophiesState>(
  (ref) => DigifitUserTrophiesController(
      digifitUserTrophiesUseCase: ref.read(digifitUserTrophiesUseCaseProvider),
      tokenStatus: ref.read(tokenStatusProvider),
      refreshTokenProvider: ref.read(refreshTokenProvider),
      localeManagerController: ref.read(localeManagerProvider.notifier),
      digifitEquipmentFav: ref.read(digifitEquipmentFavProvider)),
);

class DigifitUserTrophiesController
    extends StateNotifier<DigifitUserTrophiesState> {
  final DigifitUserTrophiesUseCase digifitUserTrophiesUseCase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;
  final LocaleManagerController localeManagerController;
  final DigifitEquipmentFav digifitEquipmentFav;

  DigifitUserTrophiesController(
      {required this.digifitUserTrophiesUseCase,
      required this.tokenStatus,
      required this.refreshTokenProvider,
      required this.localeManagerController,
      required this.digifitEquipmentFav})
      : super(DigifitUserTrophiesState.empty());

  Future<void> fetchDigifitUserTrophies() async {
    try {
      state = state.copyWith(isLoading: true);

      final isTokenExpired = tokenStatus.isAccessTokenExpired();

      if (isTokenExpired) {
        await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () {
              _fetchDigifitUserTrophies();
            });
      } else {
        // If the token is not expired, we can proceed with the request
        _fetchDigifitUserTrophies();
      }
    } catch (e) {
      debugPrint('[DigifitUserTrophiesController] Fetch Exception: $e');
    }
  }

  _fetchDigifitUserTrophies() async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();

      DigifitUserTrophiesRequestModel digifitUserTrophiesRequestModel =
          DigifitUserTrophiesRequestModel(
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}");

      DigifitUserTrophiesResponseModel digifitUserTrophiesResponseModel =
          DigifitUserTrophiesResponseModel();

      final result = await digifitUserTrophiesUseCase.call(
          digifitUserTrophiesRequestModel, digifitUserTrophiesResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: l.toString(),
          );
          debugPrint(
              '[DigifitUserTrophiesController] Fetch Error: ${l.toString()}');
        },
        (r) {
          var response = (r as DigifitUserTrophiesResponseModel);
          state = state.copyWith(
              isLoading: false, digifitUserTrophiesResponseModel: response);
        },
      );
    } catch (error) {
      debugPrint(
          '[DigifitUserTrophiesController] Fetch fold Exception: $error');
    }
  }
}