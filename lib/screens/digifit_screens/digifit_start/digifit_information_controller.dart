import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/digifit_information_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';
import 'package:domain/usecase/digifit/digifit_information_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/localization_manager.dart';
import '../../../providers/refresh_token_provider.dart';
import 'digifit_information_state.dart';

final digifitInformationControllerProvider = StateNotifierProvider.autoDispose<
    DigifitInformationController, DigifitState>(
  (ref) => DigifitInformationController(
      digifitInformationUsecase: ref.read(digifitInformationUseCaseProvider),
      tokenStatus: ref.read(tokenStatusProvider),
      refreshTokenProvider: ref.read(refreshTokenProvider),
      localeManagerController: ref.read(localeManagerProvider.notifier)),
);

class DigifitInformationController extends StateNotifier<DigifitState> {
  final DigifitInformationUseCase digifitInformationUsecase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;
  final LocaleManagerController localeManagerController;

  DigifitInformationController(
      {required this.digifitInformationUsecase,
      required this.tokenStatus,
      required this.refreshTokenProvider,
      required this.localeManagerController})
      : super(DigifitState.empty());

  Future<void> fetchDigifitInformation() async {
    try {
      state = state.copyWith(isLoading: true);

      final isTokenExpired = tokenStatus.isAccessTokenExpired();

      if (isTokenExpired) {
        await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () {
              _fetchDigifitInformation();
            });
      } else {
        // If the token is not expired, we can proceed with the request
        _fetchDigifitInformation();
      }
    } catch (e) {
      debugPrint('[DigifitInformationController] Fetch Exception: $e');
    }
  }

  _fetchDigifitInformation() async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();

      DigifitInformationRequestModel digifitInformationRequestModel =
          DigifitInformationRequestModel(
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}");

      DigifitInformationResponseModel digifitInformationResponseModel =
          DigifitInformationResponseModel();

      final result = await digifitInformationUsecase.call(
          digifitInformationRequestModel, digifitInformationResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: l.toString(),
          );
          debugPrint(
              '[DigifitInformationController] Fetch Error: ${l.toString()}');
        },
        (r) {
          var response = (r as DigifitInformationResponseModel).data;
          state = state.copyWith(
              isLoading: false, digifitInformationDataModel: response);
        },
      );
    } catch (error) {
      debugPrint('[DigifitInformationController] Fetch fold Exception: $error');
    }
  }
}
