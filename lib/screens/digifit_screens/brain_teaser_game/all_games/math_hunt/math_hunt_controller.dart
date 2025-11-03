import 'package:core/token_status.dart';
import 'package:domain/usecase/digifit/brain_teaser_game/all_game_usecase.dart';
import 'package:domain/usecase/digifit/brain_teaser_game/game_details_tracker_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';

import '../../../../../providers/refresh_token_provider.dart';
import 'math_hunt_state.dart';

final brainTeaserGameMathHuntControllerProvider =
    StateNotifierProvider.autoDispose.family<BrainTeaserGameMathHuntController,
            BrainTeaserGameMathHuntState, int>(
        (ref, levelId) => BrainTeaserGameMathHuntController(
            brainTeaserGameMathHuntUseCase:
                ref.read(brainTeaserGamesUseCaseProvider),
            tokenStatus: ref.read(tokenStatusProvider),
            refreshTokenProvider: ref.read(refreshTokenProvider),
            levelId: levelId,
            brainTeaserGameDetailsTrackingUseCase:
                ref.read(brainTeaserGameDetailsTrackingUseCaseProvider)));

class BrainTeaserGameMathHuntController
    extends StateNotifier<BrainTeaserGameMathHuntState> {
  final BrainTeaserGamesUseCase brainTeaserGameMathHuntUseCase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;
  int levelId;
  final BrainTeaserGameDetailsTrackingUseCase
      brainTeaserGameDetailsTrackingUseCase;

  BrainTeaserGameMathHuntController(
      {required this.brainTeaserGameMathHuntUseCase,
      required this.refreshTokenProvider,
      required this.tokenStatus,
      required this.levelId,
      required this.brainTeaserGameDetailsTrackingUseCase})
      : super(BrainTeaserGameMathHuntState.empty());

  Future<void> fetchBrainTeaserGameMathHunt({
    required int gameId,
    required int levelId,
  }) async {
    try {
      final isTokenExpired = tokenStatus.isAccessTokenExpired();

      if (isTokenExpired) {
        await refreshTokenProvider.getNewToken(onError: () {
          state = state.copyWith(isLoading: false);
        }, onSuccess: () {
          _fetchBrainTeaserGameMathHunt(gameId, levelId);
        });
      } else {
        _fetchBrainTeaserGameMathHunt(gameId, levelId);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint('[BrainTeaserGameMathHuntController] Exception: $e');
    }
  }

  _fetchBrainTeaserGameMathHunt(int gameId, int levelId) async {

    // try {
    //
    // }
  }
}
