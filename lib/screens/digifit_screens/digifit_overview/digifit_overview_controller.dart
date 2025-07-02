import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/digifit_overview_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_overview_response_model.dart';
import 'package:domain/usecase/digifit/digifit_overview_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../locale/localization_manager.dart';
import '../../../providers/refresh_token_provider.dart';
import 'digifit_overview_state.dart';

final digifitOverviewScreenControllerProvider = StateNotifierProvider
    .autoDispose<DigifitOverviewController, DigifitOverviewState>((ref) =>
        DigifitOverviewController(
            digifitOverviewUseCase: ref.read(digifitOverviewUseCaseProvider),
            tokenStatus: ref.read(tokenStatusProvider),
            refreshTokenProvider: ref.read(refreshTokenProvider),
            localeManagerController: ref.read(localeManagerProvider.notifier)));

class DigifitOverviewController extends StateNotifier<DigifitOverviewState> {
  final DigifitOverviewUseCase digifitOverviewUseCase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;
  final LocaleManagerController localeManagerController;

  DigifitOverviewController(
      {required this.digifitOverviewUseCase,
      required this.tokenStatus,
      required this.refreshTokenProvider,
      required this.localeManagerController})
      : super(DigifitOverviewState.empty());

  Future<void> fetchDigifitOverview(int locationId) async {
    try {
      state = state.copyWith(isLoading: true);

      final isTokenExpired = tokenStatus.isAccessTokenExpired();

      if (isTokenExpired) {
        await refreshTokenProvider.getNewToken(
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
}
