import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:domain/model/request_model/digifit/digifit_overview_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_overview_response_model.dart';
import 'package:domain/usecase/digifit/digifit_overview_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'digifit_overview_state.dart';

final digifitOverviewScreenControllerProvider = StateNotifierProvider
    .autoDispose<DigifitOverviewController, DigifitOverviewState>(
  (ref) => DigifitOverviewController(
    digifitOverviewUseCase: ref.read(digifitOverviewUseCaseProvider),
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
  ),
);

class DigifitOverviewController extends StateNotifier<DigifitOverviewState> {
  final DigifitOverviewUseCase digifitOverviewUseCase;
  final SharedPreferenceHelper sharedPreferenceHelper;

  DigifitOverviewController(
      {required this.digifitOverviewUseCase,
      required this.sharedPreferenceHelper})
      : super(DigifitOverviewState.empty());

  Future<void> fetchDigifitOverview(String location) async {
    try {
      state = state.copyWith(isLoading: true);

      DigifitOverviewRequestModel digifitOverviewRequestModel =
          DigifitOverviewRequestModel(location: location);

      DigifitOverviewResponseModel digifitOverviewResponseModel =
          DigifitOverviewResponseModel();

      final result = await digifitOverviewUseCase.call(
          digifitOverviewRequestModel, digifitOverviewResponseModel);

      result.fold((l) {
        state = state.copyWith(isLoading: false, errorMessage: l.toString());
      }, (r) {
        var response = (r as DigifitOverviewResponseModel).data;
        state = state.copyWith(
            isLoading: false, digifitOverviewDataModel: response);
      });
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }
}
