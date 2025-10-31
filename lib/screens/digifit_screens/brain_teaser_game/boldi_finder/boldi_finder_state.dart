import 'package:domain/model/response_model/digifit/brain_teaser_game/boldi_finder_response_model.dart';

import '../enum/game_session_status.dart';

class BrainTeaserGameBoldiFinderState {
  final bool isLoading;
  final String? errorMessage;
  final BoldFinderDataModel? boldFinderDataModel;
  final bool isGamePlayEnabled;
  final bool showBoldi;
  final bool showArrow;
  final bool showPause;
  final int boldiRow;
  final int boldiCol;
  final String? currentArrowDirection;
  final bool? isAnswerCorrect;
  final int? selectedRow;
  final int? selectedCol;
  final int? timer;
  final bool showSuccessDialog;
  final bool showErrorDialog;
  final GameStageConstant gameDetailsStageConstant;

  BrainTeaserGameBoldiFinderState(
      {required this.isLoading,
      this.errorMessage,
      this.boldFinderDataModel,
      required this.isGamePlayEnabled,
      required this.showBoldi,
      required this.showArrow,
      required this.showPause,
      required this.boldiRow,
      required this.boldiCol,
      this.currentArrowDirection,
      this.isAnswerCorrect,
      this.selectedRow,
      this.selectedCol,
      required this.showSuccessDialog,
      required this.showErrorDialog,
      required this.timer,
      required this.gameDetailsStageConstant});

  factory BrainTeaserGameBoldiFinderState.empty() {
    return BrainTeaserGameBoldiFinderState(
      isLoading: false,
      errorMessage: null,
      boldFinderDataModel: null,
      isGamePlayEnabled: false,
      showBoldi: false,
      showArrow: false,
      showPause: false,
      boldiRow: 0,
      boldiCol: 0,
      currentArrowDirection: null,
      isAnswerCorrect: null,
      selectedRow: null,
      selectedCol: null,
      showSuccessDialog: false,
      showErrorDialog: false,
      timer: 3,
      gameDetailsStageConstant: GameStageConstant.initial,
    );
  }

  BrainTeaserGameBoldiFinderState copyWith({
    bool? isLoading,
    String? errorMessage,
    BoldFinderDataModel? boldFinderDataModel,
    bool? isGamePlayEnabled,
    bool? showBoldi,
    bool? showArrow,
    bool? showPause,
    int? boldiRow,
    int? boldiCol,
    String? currentArrowDirection,
    bool? isAnswerCorrect,
    int? selectedRow,
    int? selectedCol,
    bool? showSuccessDialog,
    bool? showErrorDialog,
    int? timer,
    GameStageConstant? gameDetailsStageConstant,
  }) {
    return BrainTeaserGameBoldiFinderState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      boldFinderDataModel: boldFinderDataModel ?? this.boldFinderDataModel,
      isGamePlayEnabled: isGamePlayEnabled ?? this.isGamePlayEnabled,
      showBoldi: showBoldi ?? this.showBoldi,
      showArrow: showArrow ?? this.showArrow,
      showPause: showPause ?? this.showPause,
      boldiRow: boldiRow ?? this.boldiRow,
      boldiCol: boldiCol ?? this.boldiCol,
      currentArrowDirection:
          currentArrowDirection ?? this.currentArrowDirection,
      isAnswerCorrect: isAnswerCorrect,
      selectedRow: selectedRow ?? this.selectedRow,
      selectedCol: selectedCol ?? this.selectedCol,
      showSuccessDialog: showSuccessDialog ?? this.showSuccessDialog,
      showErrorDialog: showErrorDialog ?? this.showErrorDialog,
      timer: timer ?? this.timer,
      gameDetailsStageConstant:
          gameDetailsStageConstant ?? this.gameDetailsStageConstant,
    );
  }
}
