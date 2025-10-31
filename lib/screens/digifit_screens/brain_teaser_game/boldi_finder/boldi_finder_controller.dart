import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/brain_teaser_game/game_details_tracker_request_model.dart';
import 'package:domain/model/response_model/digifit/brain_teaser_game/boldi_finder_response_model.dart';
import 'package:domain/model/response_model/digifit/brain_teaser_game/game_details_tracker_response_model.dart';

import 'package:domain/usecase/digifit/brain_teaser_game/boldi_finder_usecase.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:domain/usecase/digifit/brain_teaser_game/game_details_tracker_usecase.dart';

import 'package:domain/model/request_model/digifit/brain_teaser_game/boldi_finder_request_model.dart';

import '../../../../providers/refresh_token_provider.dart';
import 'boldi_finder_state.dart';
import '../enum/game_session_status.dart';

final brainTeaserGameBoldiFinderControllerProvider =
    StateNotifierProvider.autoDispose.family<
            BrainTeaserGameBoldiFinderController,
            BrainTeaserGameBoldiFinderState,
            int>(
        (ref, levelId) => BrainTeaserGameBoldiFinderController(
            brainTeaserGameBoldiFinderUseCase:
                ref.read(brainTeaserGameBoldiFinderUseCaseProvider),
            tokenStatus: ref.read(tokenStatusProvider),
            refreshTokenProvider: ref.read(refreshTokenProvider),
            levelId: levelId,
            brainTeaserGameDetailsTrackingUseCase:
                ref.read(brainTeaserGameDetailsTrackingUseCaseProvider)));

class BrainTeaserGameBoldiFinderController
    extends StateNotifier<BrainTeaserGameBoldiFinderState> {
  final BrainTeaserGameBoldiFinderUseCase brainTeaserGameBoldiFinderUseCase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;
  int levelId;
  final BrainTeaserGameDetailsTrackingUseCase
      brainTeaserGameDetailsTrackingUseCase;

  Function(String)? onArrowUpdate;
  Function(int, int)? onBoldiUpdate;

  VoidCallback? onClearOverlays;

  bool _isSequencePaused = false;

  BrainTeaserGameBoldiFinderController(
      {required this.brainTeaserGameBoldiFinderUseCase,
      required this.tokenStatus,
      required this.refreshTokenProvider,
      required this.levelId,
      required this.brainTeaserGameDetailsTrackingUseCase})
      : super(BrainTeaserGameBoldiFinderState.empty());

  Future<void> fetchBrainTeaserGameBoldiFinder(
      {required int gameId, required int levelId}) async {
    state = state.copyWith(isLoading: true);

    try {
      final isTokenExpired = tokenStatus.isAccessTokenExpired();

      if (isTokenExpired) {
        await refreshTokenProvider.getNewToken(onError: () {
          state = state.copyWith(isLoading: false);
        }, onSuccess: () {
          _fetchBrainTeaserGameBoldiFinder(gameId, levelId);
        });
      } else {
        _fetchBrainTeaserGameBoldiFinder(gameId, levelId);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint('[BrainTeaserGameBoldiFinderController] Exception: $e');
    }
  }

  _fetchBrainTeaserGameBoldiFinder(int gameId, int levelId) async {
    try {
      BoldiFinderRequestModel boldiFinderRequestModel = BoldiFinderRequestModel(
        gameId: gameId,
        levelId: levelId,
      );

      BoldiFinderResponseModel boldiFinderResponseModel =
          BoldiFinderResponseModel();
      final result = await brainTeaserGameBoldiFinderUseCase.call(
          boldiFinderRequestModel, boldiFinderResponseModel);

      result.fold((l) {
        state = state.copyWith(isLoading: false, errorMessage: l.toString());
      }, (r) async {
        var response = (r as BoldiFinderResponseModel).data;
        state = state.copyWith(
          isLoading: false,
          boldFinderDataModel: response,
          gameDetailsStageConstant: GameStageConstant.initial,
        );

        await _showBoldiInitial();

        // Future.delayed(Duration(milliseconds: 100), () {
        //   debugPrint("🧹 Forcing overlay reset after fetch");
        //   onBoldiUpdate?.call(
        //     response?.startPosition?.row ?? 2,
        //     response?.startPosition?.col ?? 2,
        //   );
        // });
      });
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint(
          '[BrainTeaserGameBoldiFinderController] Fetch fold Exception: $e');
    }
  }

  void pauseSequence() {
    _isSequencePaused = true;
  }

  void resumeSequence() {
    _isSequencePaused = false;
  }

  Future<void> restartGame(int gameId, int levelId) async {
    _isSequencePaused = false;

    onClearOverlays?.call();

    state = state.copyWith(
      showBoldi: false,
      showArrow: false,
      showPause: false,
      isAnswerCorrect: null,
      selectedRow: null,
      selectedCol: null,
      showSuccessDialog: false,
      showErrorDialog: false,
      isGamePlayEnabled: false,
    );

    await fetchBrainTeaserGameBoldiFinder(gameId: gameId, levelId: levelId);
  }

  Future<void> _showBoldiInitial() async {
    final startPos = state.boldFinderDataModel?.startPosition;
    if (startPos == null) return;

    final row = startPos.row;
    final col = startPos.col;

    state = state.copyWith(
      showBoldi: true,
      boldiRow: row,
      boldiCol: col,
      gameDetailsStageConstant: GameStageConstant.initial,
      isGamePlayEnabled: false,
    );

    onBoldiUpdate?.call(row!, col!);
  }

  Future<void> startGameSequence() async {
    try {
      _isSequencePaused = false;

      state = state.copyWith(
        gameDetailsStageConstant: GameStageConstant.progress,
        isGamePlayEnabled: false,
        showBoldi: true,
      );

      await Future.delayed(const Duration(seconds: 1));

      if (_isSequencePaused) return;

      state = state.copyWith(showBoldi: false);

      await _showArrowSequence();

      if (_isSequencePaused) return;

      await _showPauseIcon();

      if (_isSequencePaused) return;

      _enableGamePlay();
    } catch (e) {
      debugPrint(
          '[BrainTeaserGameBoldiFinderController] startGameSequence Exception: $e');
    }
  }

  Future<void> startGameFlow() async {
    try {
      state = state.copyWith(
        isGamePlayEnabled: false,
        showBoldi: false,
        showArrow: false,
        showPause: false,
        currentArrowDirection: null,
        isAnswerCorrect: null,
        showSuccessDialog: false,
        showErrorDialog: false,
      );

      await _showBoldi();

      await _showArrowSequence();

      await _showPauseIcon();

      _enableGamePlay();
    } catch (e) {
      debugPrint(
          '[BrainTeaserGameBoldiFinderController] startGameFlow Exception: $e');
    }
  }

  Future<void> _showBoldi() async {
    final row = state.boldFinderDataModel?.startPosition?.row ?? 0;
    final col = state.boldFinderDataModel?.startPosition?.col ?? 0;

    state = state.copyWith(
      showBoldi: true,
      boldiRow: row,
      boldiCol: col,
    );

    onBoldiUpdate?.call(row, col);

    await Future.delayed(const Duration(seconds: 1));

    state = state.copyWith(showBoldi: false);
  }

  Future<void> _showArrowSequence() async {
    final steps = state.boldFinderDataModel?.steps ?? [];
    final timerSeconds = state.boldFinderDataModel?.timer ?? 3;

    for (int i = 0; i < steps.length; i++) {
      while (_isSequencePaused) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      final stepString = steps[i];

      if (i > 0) {
        state = state.copyWith(
          showArrow: false,
          currentArrowDirection: null,
        );

        await Future.delayed(const Duration(milliseconds: 150));

        while (_isSequencePaused) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }

      state = state.copyWith(
        showArrow: true,
        currentArrowDirection: stepString,
      );

      onArrowUpdate?.call(stepString);

      for (int j = 0; j < timerSeconds * 10; j++) {
        while (_isSequencePaused) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    while (_isSequencePaused) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    state = state.copyWith(
      showArrow: false,
      currentArrowDirection: null,
    );

    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> _showPauseIcon() async {
    while (_isSequencePaused) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    state = state.copyWith(showPause: true);

    for (int i = 0; i < 10; i++) {
      while (_isSequencePaused) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }

    state = state.copyWith(showPause: false);
  }

  void _enableGamePlay() {
    state = state.copyWith(
      isGamePlayEnabled: true,
      gameDetailsStageConstant: GameStageConstant.progress,
    );
  }

  Future<void> checkAnswer(int row, int column, VoidCallback onSuccess) async {
    if (!state.isGamePlayEnabled) {
      return;
    }

    state = state.copyWith(
      isGamePlayEnabled: false,
      isLoading: true,
    );

    final finalRow = state.boldFinderDataModel?.finalPosition?.row ?? -1;
    final finalCol = state.boldFinderDataModel?.finalPosition?.col ?? -1;

    debugPrint(
        'User clicked: ($row, $column) | Expected: ($finalRow, $finalCol)');

    final isCorrect = (row == finalRow && column == finalCol);

    var status =
        isCorrect ? GameStageConstant.complete : GameStageConstant.abort;

    final sessionId = state.boldFinderDataModel?.sessionId ?? 0;

    try {
      await trackGameDetails(sessionId, status, () {
        _showAnswerResult(row, column, isCorrect);
        onSuccess();
      });
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isGamePlayEnabled: true,
        errorMessage: 'Failed to submit answer. Please try again.',
      );
    }
  }

  void _showAnswerResult(int row, int column, bool isCorrect) {
    state = state.copyWith(
      isLoading: false,
      showBoldi: false,
      showArrow: false,
      showPause: false,
      isAnswerCorrect: isCorrect,
      selectedRow: row,
      selectedCol: column,
      showSuccessDialog: isCorrect,
      showErrorDialog: !isCorrect,
      gameDetailsStageConstant:
          isCorrect ? GameStageConstant.complete : GameStageConstant.abort,
    );
  }

  Future<void> trackGameDetails(
      int sessionId,
      GameStageConstant gameDetailsStageConstant,
      VoidCallback onSuccess) async {
    try {
      state = state.copyWith(isLoading: true);
      final isTokenExpired = tokenStatus.isAccessTokenExpired();
      if (isTokenExpired) {
        await refreshTokenProvider.getNewToken(
          onError: () {
            state = state.copyWith(isLoading: false);
          },
          onSuccess: () async {
            await _trackGameDetails(
                sessionId, gameDetailsStageConstant, onSuccess);
          },
        );
      } else {
        await _trackGameDetails(sessionId, gameDetailsStageConstant, onSuccess);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint(
          '[BrainTeaserGameBoldiFinderController] track game Exception: $e');
    }
  }

  _trackGameDetails(int sessionId, GameStageConstant gameDetailsStageConstant,
      VoidCallback onSuccess) async {
    try {
      GamesTrackerRequestModel gameDetailsTrackingRequestModel =
          GamesTrackerRequestModel(
              sessionId: sessionId,
              activityStatus: gameDetailsStageConstant.name);

      GamesTrackerResponseModel gamesTrackerResponseModel =
          GamesTrackerResponseModel();

      final result = await brainTeaserGameDetailsTrackingUseCase.call(
          gameDetailsTrackingRequestModel, gamesTrackerResponseModel);

      result.fold((l) {
        state = state.copyWith(isLoading: false, errorMessage: l.toString());
        debugPrint(
            '[BrainTeaserGameBoldiFinderController] track game Fetch fold Error: ${l.toString()}');
      }, (r) {
        var response = (r as GamesTrackerResponseModel).data;
        onSuccess();
      });
    } catch (e) {
      debugPrint(
          '[BrainTeaserGameBoldiFinderController] track game Fetch  Exception: $e');
    }
  }
}
