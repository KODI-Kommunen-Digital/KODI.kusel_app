import 'package:domain/model/request_model/feedback/feedback_request_model.dart';
import 'package:domain/model/response_model/feedback/feedback_response_model.dart';
import 'package:domain/usecase/feedback/feedback_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/feedback/feedback_screen_state.dart';

final feedbackScreenProvider = StateNotifierProvider.autoDispose<
        FeedbackScreenProvider, FeedbackScreenState>(
    (ref) => FeedbackScreenProvider(
        feedBackUseCase: ref.read(feedBackUseCaseProvider)));

class FeedbackScreenProvider extends StateNotifier<FeedbackScreenState> {
  FeedBackUseCase feedBackUseCase;

  final TextEditingController titleEditingController = TextEditingController();
  final TextEditingController descriptionEditingController =
      TextEditingController();

  FeedbackScreenProvider({required this.feedBackUseCase})
      : super(FeedbackScreenState.empty());

  Future<void> sendFeedback(
      {required void Function() success,
        required void Function(String msg) onError,
      required String title,
      required String description}) async {
    try {
      state = state.copyWith(loading: true);
      FeedBackRequestModel requestModel =
          FeedBackRequestModel(title: title, description: description);
      FeedBackResponseModel responseModel = FeedBackResponseModel();
      final r = await feedBackUseCase.call(requestModel, responseModel);
      r.fold((l) {
        debugPrint('Feedback fold exception : $l');
        onError(l.toString());
        state = state.copyWith(loading: false);
      }, (r) async {
        final result = r as FeedBackResponseModel;
        success();
        state = state.copyWith(loading: false);
      });
    } catch (error) {
      onError(error.toString());
      debugPrint('Feedback exception : $error');
      state = state.copyWith(loading: false);
    }
  }
}
