import 'package:domain/model/empty_request.dart';
import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';
import 'package:domain/usecase/digifit/digifit_information_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'digifit_information_state.dart';

final digifitInformationControllerProvider = StateNotifierProvider.autoDispose<
    DigifitInformationController, DigitfitState>(
  (ref) => DigifitInformationController(
      digifitInformationUsecase: ref.read(digifitInformationUseCaseProvider)),
);

class DigifitInformationController extends StateNotifier<DigitfitState> {
  final DigifitInformationUseCase digifitInformationUsecase;

  DigifitInformationController({required this.digifitInformationUsecase})
      : super(DigitfitState.empty());

  Future<void> fetchDigifitInformation() async {
    try {
      state = state.copyWith(isLoading: true);

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
        },
        (r) {
          var response = (r as DigifitInformationResponseModel).data;
          state = state.copyWith(
              isLoading: false, digifitInformationDataModel: response);
        },
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }
}
