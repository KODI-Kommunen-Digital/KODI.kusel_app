import 'package:domain/model/empty_request.dart';
import 'package:domain/model/response_model/participate/participate_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/participate_screen/participate_screen_state.dart';
import 'package:domain/usecase/participate/participate_usecase.dart';
final participateScreenProvider = StateNotifierProvider.autoDispose<
    ParticipateScreenProvider,
    ParticipateScreenState>((ref) => ParticipateScreenProvider(
  participateUseCase: ref.read(participateUseCaseProvider)
));

class ParticipateScreenProvider extends StateNotifier<ParticipateScreenState> {
  ParticipateUseCase participateUseCase;
  ParticipateScreenProvider({required this.participateUseCase}) : super(ParticipateScreenState.empty());

  Future<void> fetchParticipateDetails() async {
    try {
      state = state.copyWith(isLoading: true);

      EmptyRequest requestModel = EmptyRequest();

      ParticipateResponseModel responseModel = ParticipateResponseModel();

      final response = await participateUseCase.call(requestModel, responseModel);

      response.fold((l) {
        state = state.copyWith(isLoading: false);
        debugPrint("Participate fold exception = ${l.toString()}");
      }, (r) {
        final result = r as ParticipateResponseModel;
        if (result.data != null) {
          state = state.copyWith(
            participateData: result.data,
            isLoading: false,
          );
        }
      });
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint("Participate Ort exception = $e");
    }
  }

}
