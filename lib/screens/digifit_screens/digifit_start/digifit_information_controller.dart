import 'package:core/token_status.dart';
import 'package:domain/model/empty_request.dart';
import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';
import 'package:domain/usecase/digifit/digifit_information_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/refresh_token_provider.dart';
import 'digifit_information_state.dart';

final digifitInformationControllerProvider = StateNotifierProvider.autoDispose<
    DigifitInformationController, DigifitState>(
  (ref) => DigifitInformationController(
      digifitInformationUsecase: ref.read(digifitInformationUseCaseProvider),
      tokenStatus: ref.read(tokenStatusProvider),
      refreshTokenProvider: ref.read(refreshTokenProvider)),
);

class DigifitInformationController extends StateNotifier<DigifitState> {
  final DigifitInformationUseCase digifitInformationUsecase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;

  DigifitInformationController(
      {required this.digifitInformationUsecase,
      required this.tokenStatus,
      required this.refreshTokenProvider})
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
      EmptyRequest emptyRequest = EmptyRequest();

      DigifitInformationResponseModel digifitInformationResponseModel =
          DigifitInformationResponseModel();

      final result = await digifitInformationUsecase.call(
          emptyRequest, digifitInformationResponseModel);
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
