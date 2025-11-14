import 'dart:async';

import 'package:domain/model/response_model/digifit/brain_teaser_game/pictures_game_response_model.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';

import '../../../../../common_widgets/common_background_clipper_widget.dart';
import '../../../../../common_widgets/common_bottom_nav_card_.dart';
import '../../../../../common_widgets/common_html_widget.dart';
import '../../../../../common_widgets/device_helper.dart';
import '../../../../../common_widgets/digifit/brain_teaser_game/game_status_card.dart';
import '../../../../../common_widgets/digifit/brain_teaser_game/grid_widget.dart';
import '../../../../../common_widgets/text_styles.dart';
import '../../../../../common_widgets/upstream_wave_clipper.dart';
import '../../../../../images_path.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../navigation/navigation.dart';
import '../../../digifit_start/digifit_information_controller.dart';
import '../../enum/game_session_status.dart';
import '../../game_details/details_controller.dart';
import '../params/all_game_params.dart';
import 'component/component.dart';
import 'component/cross_mark_overlay.dart';
import 'component/grid_common.dart';
import 'component/pair.dart';
import 'pictures_game_controller.dart';
import 'pictures_game_state.dart';

class PicturesGameScreen extends ConsumerStatefulWidget {
  final AllGameParams? picturesGameParams;

  const PicturesGameScreen({super.key, required this.picturesGameParams});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PicturesGameScreenState();
  }
}

class _PicturesGameScreenState extends ConsumerState<PicturesGameScreen> {
  CommonGridWidgets? _gridGame;
  final GlobalKey _gridKey = GlobalKey();

  // Pre-load all game instances
  final List<PairDisplayGame> _memorizeGames = [];
  final List<PairDisplayGame> _checkGames = [];
  bool _gamesInitialized = false;

  PictureOverlayGame? _level3OverlayGame;
  PictureOverlayGame? _initialPicturesGame;
  PlaceholderOverlayGame? _placeholderGame;
  PlaceholderOverlayGame? _level3PlaceholderGame; // Level 3 ke liye
  final Map<String, PictureOverlayGame> _revealedCellGames = {};
  CrossMarkOverlayGame? _crossMarkGame;

  // Track grid recreation - ADD THESE
  int? _lastRows;
  int? _lastCols;
  int? _lastLevelId;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      final controller = ref.read(
        picturesGameControllerProvider(
          widget.picturesGameParams?.levelId ?? 1,
        ).notifier,
      );

      controller.fetchGameData(
        gameId: widget.picturesGameParams?.gameId ?? 1,
        levelId: widget.picturesGameParams?.levelId ?? 1,
      );
    });
  }

  void _initializeGames(PicturesGameState state, double imageHeight) {
    if (_gamesInitialized) return;

    final memorizePairs = state.gameData?.memorizePairs ?? [];
    final checkPairs = state.gameData?.checkPairs ?? [];
    final sourceId = state.gameData?.sourceId ?? 1;

    if (memorizePairs.isEmpty && checkPairs.isEmpty) return;

    const imageSpacing = 16.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - 40 - 40; // minus margins and padding

    _memorizeGames.clear();
    for (var pair in memorizePairs) {
      _memorizeGames.add(
        PairDisplayGame(
          image1Url: pair.image1 ?? '',
          image2Url: pair.image2 ?? '',
          width: cardWidth,
          height: imageHeight,
          sourceId: sourceId,
          showButtons: false,
        ),
      );
    }

    _checkGames.clear();
    for (var pair in checkPairs) {
      _checkGames.add(
        PairDisplayGame(
          image1Url: pair.image1 ?? '',
          image2Url: pair.image2 ?? '',
          width: cardWidth,
          height: imageHeight,
          sourceId: sourceId,
          showButtons: true,
        ),
      );
    }

    _gamesInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      picturesGameControllerProvider(
        widget.picturesGameParams?.levelId ?? 1,
      ),
    );

    // Show Level 3 dialog when needed
    if (state.showLevel3Dialog && !state.level3Completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showLevel3ImageSelectionDialog(context, state);
        }
      });
    }

    final headingText = widget.picturesGameParams?.title ?? '';
    final useInnerPadding = true;
    final levelId = widget.picturesGameParams?.levelId ?? 1;

    final rows = state.rows;
    final columns = state.columns;
    final gridWidth = 330.w;
    final tileWidth = gridWidth / columns;
    final tileHeight = tileWidth;
    final gridHeight = rows * tileHeight;

    final shouldShowLevel2 =
        state.isLevel2 && !state.isLevel3 || (state.isLoading && levelId == 2);
    final shouldShowLevel3 = state.isLevel3;


    final shouldRecreateGrid = _gridGame == null ||
        _lastRows != rows ||
        _lastCols != columns ||
        _lastLevelId != levelId ||
        (_lastLevelId == 3 &&
            !state.isLevel3) || // Recreate when leaving Level 3
        (_lastLevelId != 3 && state.isLevel3); // Recreate when entering Level 3

    if (shouldRecreateGrid) {
      _gridGame = CommonGridWidgets(
        params: CommonGridParamss(
          width: gridWidth,
          height: gridHeight,
          tileHeight: tileHeight,
          tileWidth: tileWidth,
          rows: rows,
          columns: columns,
          borderColor: Theme.of(context).dividerColor,
          useInnerPadding: useInnerPadding,
          onCellTapped: _handleCellTap,
          currentTime: state.maxTimerSeconds,
          maxTime: state.maxTimerSeconds,
          showTimer: !state.isLevel3,
        ),
      );
      _lastRows = rows;
      _lastCols = columns;
      _lastLevelId = levelId;

      _level3OverlayGame = null;
      _initialPicturesGame = null;
      _placeholderGame = null;
      _revealedCellGames.clear();
      _crossMarkGame = null;
    } else if (_gridGame != null) {
      // Update timer
      if (state.isGameInProgress && !state.isLevel2 && !state.isLevel3) {
        _gridGame!.params.currentTime = state.timerSeconds;
      } else {
        _gridGame!.params.currentTime = state.maxTimerSeconds;
      }
    }


    if (state.isLevel3) {
      final shouldRecreateLevel3 = _level3OverlayGame == null ||
          (_lastLevelId == 3 &&
              state.isGameInProgress &&
              _level3OverlayGame != null);

      if (shouldRecreateLevel3) {
        _level3OverlayGame = PictureOverlayGame(
          pictures: _getPicturePositionsLevel3(state),
          gridWidth: gridWidth,
          gridHeight: gridHeight,
          tileWidth: tileWidth,
          tileHeight: tileHeight,
          gridRows: rows,
          gridColumns: columns,
        );
      }
    } else {
      _level3OverlayGame = null;
    }

    if (!state.isLevel3 &&
        state.isInitialStage &&
        state.gameData?.pictureGrid != null &&
        _initialPicturesGame == null) {
      _initialPicturesGame = PictureOverlayGame(
        pictures: _getPicturePositions(state),
        gridWidth: gridWidth,
        gridHeight: gridHeight,
        tileWidth: tileWidth,
        tileHeight: tileHeight,
        gridRows: rows,
        gridColumns: columns,
      );
    } else if (!state.isInitialStage) {
      _initialPicturesGame = null; // Clear when not initial stage
    }

    if (!state.isLevel3 &&
        !state.isLevel2 &&
        state.isGameInProgress &&
        _placeholderGame == null) {
      _placeholderGame = PlaceholderOverlayGame(
        rows: state.rows,
        columns: state.columns,
        gridWidth: gridWidth,
        gridHeight: gridHeight,
        tileWidth: tileWidth,
        tileHeight: tileHeight,
      );
    } else if (!state.isGameInProgress || state.isLevel2 || state.isLevel3) {
      _placeholderGame = null; // Clear when not needed
    }

    final currentRevealedKeys = state.revealedCells
        .map((cell) => 'revealed_${cell.row}_${cell.col}')
        .toSet();

    _revealedCellGames
        .removeWhere((key, _) => !currentRevealedKeys.contains(key));

    // Add new revealed cells
    for (var cell in state.revealedCells) {
      final key = 'revealed_${cell.row}_${cell.col}';
      if (!_revealedCellGames.containsKey(key)) {
        String imageUrl = '';

        if (state.isLevel3) {
          final allImages = state.gameData?.allImagesList ?? [];
          ImageWithId? selectedImage;
          try {
            selectedImage = allImages.firstWhere(
              (img) => img.id.toString() == cell.imageId,
            );
          } catch (_) {
            selectedImage = null;
          }
          imageUrl =
              selectedImage?.image ?? 'admin/games/picturegame/empty.png';
        } else {
          imageUrl = _getImageUrlForCell(state, cell.row, cell.col);
        }

        _revealedCellGames[key] = PictureOverlayGame(
          pictures: [
            PicturePosition(
              row: cell.row,
              col: cell.col,
              imageUrl: imageUrl,
            ),
          ],
          gridWidth: gridWidth,
          gridHeight: gridHeight,
          tileWidth: tileWidth,
          tileHeight: tileHeight,
          gridRows: rows,
          gridColumns: columns,
        );
      }
    }

    if (state.showResult &&
        state.isAnswerCorrect == false &&
        state.wrongRow != null) {
      _crossMarkGame ??= CrossMarkOverlayGame(
        wrongRow1: state.wrongRow!,
        wrongCol1: state.wrongCol!,
        wrongRow2: state.wrongRow2 ?? state.wrongRow!,
        wrongCol2: state.wrongCol2 ?? state.wrongCol!,
        gridWidth: gridWidth,
        gridHeight: gridHeight,
        tileWidth: tileWidth,
        tileHeight: tileHeight,
      );
    } else {
      _crossMarkGame = null; // Clear when not showing wrong answer
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop == false) {
          await _handleBackNavigation(context);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Stack(
                    children: [
                      CommonBackgroundClipperWidget(
                        height: 145.h,
                        clipperType: UpstreamWaveClipper(),
                        imageUrl: imagePath['home_screen_background'] ?? '',
                        isStaticImage: true,
                      ),
                      Positioned(
                        top: 50.h,
                        left: 10.r,
                        child: _buildHeader(headingText),
                      ),
                      Column(
                        children: [
                          130.verticalSpace,
                          if (shouldShowLevel2)
                            _buildLevel2Content(state, gridWidth, context)
                          else
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: gridHeight,
                                width: gridWidth,
                                child: _buildGameStack(
                                  state: state,
                                  gridWidth: gridWidth,
                                  gridHeight: gridHeight,
                                  tileWidth: tileWidth,
                                  tileHeight: tileHeight,
                                  context: context,
                                  rows: rows,
                                  col: columns,
                                ),
                              ),
                            ),
                          10.verticalSpace,
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 80,
                            ),
                            child: CommonHtmlWidget(
                              fontSize: 16,
                              data: widget.picturesGameParams?.desc ?? '',
                            ),
                          ),
                          state.showResult ? 80.verticalSpace : 1.verticalSpace
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20.h,
                left: 16.w,
                right: 16.w,
                child: CommonBottomNavCard(
                  onBackPress: () async {
                    await _handleBackNavigation(context);
                  },
                  isFavVisible: false,
                  isFav: false,
                  onGameStageConstantTap: _handleBottomNavTap,
                  gameDetailsStageConstant: state.gameStage,
                ),
              ),
              if (state.showResult)
                Positioned(
                  bottom: 80.h,
                  left: 0,
                  right: 0,
                  child: GameStatusCardWidget(
                    isStatus: state.isAnswerCorrect ?? false,
                    description: () {
                      switch (widget.picturesGameParams?.levelId ?? 1) {
                        case 13:
                          return AppLocalizations.of(context)
                              .successful_game_desc_for_level_1;
                        case 14:
                          return AppLocalizations.of(context)
                              .successful_game_desc_for_level_2;
                        case 15:
                          return AppLocalizations.of(context)
                              .successful_game_desc_for_level_3;
                        default:
                          return "Great effort! Keep pushing your limits.";
                      }
                    }(),
                  ),
                ),
            ],
          ),
        ).loaderDialog(context, state.isLoading),
      ),
    );
  }

  @override
  void dispose() {
    _revealedCellGames.clear();
    _memorizeGames.clear();
    _checkGames.clear();
    super.dispose();
  }

  Widget _buildLevel2Content(
    PicturesGameState state,
    double width,
    BuildContext context,
  ) {
    final memorizePairs = state.gameData?.memorizePairs ?? [];
    final checkPairs = state.gameData?.checkPairs ?? [];

    const cardPadding = 20.0;
    const imageSpacing = 10.0;
    const buttonHeight = 50.0;
    const buttonSpacing = 8.0;

    final imageWidth = (width - cardPadding * 2 - imageSpacing) / 2;
    final imageHeight = imageWidth * 1.2;
    final cardHeight =
        cardPadding + imageHeight + buttonSpacing + buttonHeight + cardPadding;

    final screenWidth = MediaQuery.of(context).size.width;

    if (state.gameData != null && !_gamesInitialized) {
      _initializeGames(state, imageHeight);
    }

    if (state.isLoading || state.gameData == null || !_gamesInitialized) {
      return Container(
        width: screenWidth,
        height: cardHeight,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
      );
    }

    // Memorize phase
    if (state.isMemorizePhase && state.showMemorizePair) {
      if (state.currentPairIndex < _memorizeGames.length) {
        final game = _memorizeGames[state.currentPairIndex];

        return Column(
          children: [
            if (state.isGameInProgress && state.timerSeconds > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Level2TimerWidget(seconds: state.timerSeconds),
              ),

            Container(
              width: screenWidth,
              height: cardHeight,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 10.0, top: 40.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: imageHeight,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        reverseDuration: const Duration(milliseconds: 600),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        layoutBuilder: (currentChild, previousChildren) {
                          return Stack(
                            fit: StackFit.expand,
                            alignment: Alignment.center,
                            children: <Widget>[
                              ...previousChildren,
                              if (currentChild != null) currentChild,
                            ],
                          );
                        },
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: GameWidget(
                          key: ValueKey('memorize_${state.currentPairIndex}'),
                          game: game,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            16.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  textSemiBoldPoppins(
                    text:
                        '${state.currentPairIndex + 1}/${memorizePairs.length}',
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  8.verticalSpace,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value:
                          (state.currentPairIndex + 1) / memorizePairs.length,
                      minHeight: 8,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    }

    // Check phase
    if (state.isCheckPhase && state.showCheckPair) {
      if (state.currentPairIndex < _checkGames.length) {
        final game = _checkGames[state.currentPairIndex];

        return Column(
          children: [
            if (state.timerSeconds > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Level2TimerWidget(seconds: state.timerSeconds),
              ),

            Container(
              width: screenWidth,
              height: cardHeight,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 10.0, top: 20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: imageHeight,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        reverseDuration: const Duration(milliseconds: 600),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        layoutBuilder: (currentChild, previousChildren) {
                          return Stack(
                            fit: StackFit.expand,
                            alignment: Alignment.center,
                            children: <Widget>[
                              ...previousChildren,
                              if (currentChild != null) currentChild,
                            ],
                          );
                        },
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: GameWidget(
                          key: ValueKey('check_${state.currentPairIndex}'),
                          game: game,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              final controller = ref.read(
                                picturesGameControllerProvider(
                                  widget.picturesGameParams?.levelId ?? 1,
                                ).notifier,
                              );
                              controller.handleUserAnswer(true);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 16),
                              height: buttonHeight,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Richtig',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: imageSpacing),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              final controller = ref.read(
                                picturesGameControllerProvider(
                                  widget.picturesGameParams?.levelId ?? 1,
                                ).notifier,
                              );
                              controller.handleUserAnswer(false);
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 12, right: 10),
                              height: buttonHeight,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF44336),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Falsch',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    }

    // White card when memorization complete
    if (state.isMemorizePhase &&
        !state.showMemorizePair &&
        state.memorizationComplete) {
      return Container(
        width: screenWidth,
        height: cardHeight,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildGameStack({
    required PicturesGameState state,
    required double gridWidth,
    required double gridHeight,
    required double tileWidth,
    required double tileHeight,
    required BuildContext context,
    required int rows,
    required int col,
  }) {
    return Stack(
      children: [
        // 🟦 Base Grid with Timer
        if (_gridGame != null) GameWidget(key: _gridKey, game: _gridGame!),

        // 🟨 Level 3 Grid - Use stored instance but recreate when stage changes
        if (_level3OverlayGame != null)
          IgnorePointer(
            child: GameWidget(
              key: ValueKey('level3_${state.gameStage.name}'),
              game: _level3OverlayGame!,
            ),
          ),

        // 🟢 Level 1 Initial Grid - Use stored instance
        if (_initialPicturesGame != null)
          IgnorePointer(
            child: GameWidget(
              key: const ValueKey('initial_pictures'),
              game: _initialPicturesGame!,
            ),
          ),

        // 🟡 Placeholders - Use stored instance
        if (_placeholderGame != null)
          IgnorePointer(
            child: GameWidget(
              key: const ValueKey('placeholders'),
              game: _placeholderGame!,
            ),
          ),

        // 🔵 Revealed cells - Use stored instances from map
        ..._revealedCellGames.entries.map((entry) {
          return IgnorePointer(
            child: GameWidget(
              key: ValueKey(entry.key),
              game: entry.value,
            ),
          );
        }).toList(),

        // ❌ Cross Mark - Use stored instance
        if (_crossMarkGame != null)
          IgnorePointer(
            child: GameWidget(
              key: const ValueKey('cross_mark'),
              game: _crossMarkGame!,
            ),
          ),
      ],
    );
  }

  List<PicturePosition> _getPicturePositions(PicturesGameState state) {
    final pictures = <PicturePosition>[];
    final pictureGrid = state.gameData?.pictureGrid ?? [];
    for (int i = 0; i < pictureGrid.length; i++) {
      final row = i ~/ state.columns;
      final col = i % state.columns;
      pictures.add(PicturePosition(
          row: row, col: col, imageUrl: pictureGrid[i].image1 ?? ''));
    }
    return pictures;
  }

  String _getImageUrlForCell(PicturesGameState state, int row, int col) {
    final pictureGrid = state.gameData?.pictureGrid ?? [];
    final index = row * state.columns + col;
    return index < pictureGrid.length ? pictureGrid[index].image1 ?? '' : '';
  }

  Widget _buildHeader(String headingText) {
    return Row(
      children: [
        IconButton(
          onPressed: () async => await _handleBackNavigation(context),
          icon: Icon(
            Icons.arrow_back,
            size: DeviceHelper.isMobile(context) ? null : 12.h.w,
            color: Theme.of(context).primaryColor,
          ),
        ),
        2.horizontalSpace,
        textSemiBoldPoppins(
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: Theme.of(context).textTheme.bodyLarge?.color,
          text: headingText,
        ),
      ],
    );
  }

  Future<void> _handleBottomNavTap() async {
    if (!mounted) return;
    final controller = ref.read(
        picturesGameControllerProvider(widget.picturesGameParams?.levelId ?? 1)
            .notifier);
    final state = ref.read(picturesGameControllerProvider(
        widget.picturesGameParams?.levelId ?? 1));

    switch (state.gameStage) {
      case GameStageConstant.initial:
        await controller.startGame();
        break;
      case GameStageConstant.progress:
        await _handleBackNavigation(context);
        break;
      case GameStageConstant.abort:
        // UPDATED: Reset games initialization on restart
        _gamesInitialized = false;
        _memorizeGames.clear();
        _checkGames.clear();
        await controller.restartGame(widget.picturesGameParams?.gameId ?? 1,
            widget.picturesGameParams?.levelId ?? 1);
        break;
      case GameStageConstant.complete:
        await _handleBackNavigation(context);
        break;
    }
  }

  void _handleCellTap(int row, int column) {
    if (!mounted) return;
    ref
        .read(picturesGameControllerProvider(
                widget.picturesGameParams?.levelId ?? 1)
            .notifier)
        .handleCellTap(row, column);
  }

  Future<void> _handleBackNavigation(BuildContext context) async {
    if (!mounted) return;
    final state = ref.read(picturesGameControllerProvider(
        widget.picturesGameParams?.levelId ?? 1));

    switch (state.gameStage) {
      case GameStageConstant.progress:
        await _showAbortDialog(context);
        break;
      case GameStageConstant.complete:
        await _showCompletionDialog(context);
        break;
      default:
        if (mounted)
          ref.read(navigationProvider).removeTopPage(context: context);
    }
  }

  Future<void> _showAbortDialog(BuildContext context) async {
    if (!mounted) return;

    final controller = ref.read(
      picturesGameControllerProvider(
        widget.picturesGameParams?.levelId ?? 1,
      ).notifier,
    );

    // Pause timer when showing dialog
    controller.pauseGameTimer();
    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CupertinoAlertDialog(
        title: textBoldPoppins(
            text: AppLocalizations.of(context).abort_pictures_game,
            textAlign: TextAlign.center,
            fontSize: 16),
        content: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: textRegularPoppins(
              text: AppLocalizations.of(context).abort_game_desc,
              textAlign: TextAlign.center,
              textOverflow: TextOverflow.visible,
              fontSize: 12),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              if (!mounted) return;
              controller.resumeGameTimer();
              ref.read(navigationProvider).removeDialog(context: context);
            },
            isDefaultAction: true,
            child: textBoldPoppins(
                text: AppLocalizations.of(context).cancel,
                textOverflow: TextOverflow.visible,
                fontSize: 14),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              if (!mounted) return;
              final controller = ref.read(picturesGameControllerProvider(
                      widget.picturesGameParams?.levelId ?? 1)
                  .notifier);
              await ref.read(navigationProvider).removeDialog(context: context);
              if (!mounted) return;
              await controller.trackGameProgress(GameStageConstant.abort,
                  onSuccess: () {
                if (mounted) {
                  ref.read(navigationProvider).removeTopPage(context: context);
                }
              });
            },
            child: textBoldPoppins(
                text: AppLocalizations.of(context).digifit_abort,
                textOverflow: TextOverflow.visible,
                fontSize: 14),
          ),
        ],
      ),
    );
  }

  Future<void> _showCompletionDialog(BuildContext context) async {
    if (!mounted) return;

    String text = ((widget.picturesGameParams?.levelId ?? 13) == 13 ||
        (widget.picturesGameParams?.levelId ?? 1) == 13)
        ? AppLocalizations.of(context).level_complete_desc
        : AppLocalizations.of(context).all_level_complete;


    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CupertinoAlertDialog(
        title: textBoldPoppins(
            text: AppLocalizations.of(context).level_complete,
            textAlign: TextAlign.center,
            fontSize: 16),
        content: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: textRegularPoppins(
              text: text,
              textAlign: TextAlign.center,
              textOverflow: TextOverflow.visible,
              fontSize: 12),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () async {
              if (!mounted) return;
              ref.read(navigationProvider).removeDialog(context: context);
              if (!mounted) return;
              ref.read(navigationProvider).removeTopPage(context: context);
              Future.microtask(() async {
                await ref
                    .read(brainTeaserGameDetailsControllerProvider(
                            widget.picturesGameParams?.gameId ?? 1)
                        .notifier)
                    .fetchBrainTeaserGameDetails(
                        gameId: widget.picturesGameParams?.gameId ?? 1);
                ref
                    .read(digifitInformationControllerProvider.notifier)
                    .fetchDigifitInformation();
              });
            },
            isDefaultAction: true,
            child: textBoldPoppins(
                text: AppLocalizations.of(context).ok,
                textOverflow: TextOverflow.visible,
                fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Replace your _showLevel3ImageSelectionDialog method with this updated version:

  Future<void> _showLevel3ImageSelectionDialog(
    BuildContext context,
    PicturesGameState state,
  ) async {
    if (!mounted) return;

    final allImages = state.gameData?.allImagesList ?? [];
    if (allImages.isEmpty) return;

    bool wasTimeout = false;
    bool dialogClosed = false;

    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Level3DialogWithTimer(
        allImages: allImages,
        initialSeconds: state.timerSeconds,
        onImageSelected: (selectedImageId) {
          if (!mounted || dialogClosed) return;
          dialogClosed = true;

          // Close dialog
          ref.read(navigationProvider).removeDialog(context: context);

          // Handle selection
          final controller = ref.read(
            picturesGameControllerProvider(
              widget.picturesGameParams?.levelId ?? 1,
            ).notifier,
          );
          controller.handleLevel3ImageSelection(selectedImageId);
        },
        onTimeout: () {
          wasTimeout = true;
        },
        onCloseDialog: () {
          if (!mounted || dialogClosed) return;
          dialogClosed = true;

          final controller = ref.read(
            picturesGameControllerProvider(
              widget.picturesGameParams?.levelId ?? 1,
            ).notifier,
          );
          controller.state = controller.state.copyWith(
            showLevel3Dialog: false,
            level3TimerComplete: false,
          );

          ref.read(navigationProvider).removeDialog(context: context);
        },
      ),
    );

    if (mounted && wasTimeout) {
      final controller = ref.read(
        picturesGameControllerProvider(
          widget.picturesGameParams?.levelId ?? 1,
        ).notifier,
      );

      final displayList = state.gameData?.displayImagesList ?? [];
      final missingRow = state.missingImageRow;
      final missingCol = state.missingImageCol;
      final List<RevealedCell> displayRevealedCells = [];

      for (int i = 0; i < displayList.length; i++) {
        final displayImage = displayList[i];
        final row = i ~/ state.columns;
        final col = i % state.columns;

        // Skip the missing cell position
        if (row == missingRow && col == missingCol) {
          continue;
        }

        if (displayImage.image != null &&
            displayImage.image!.isNotEmpty &&
            displayImage.image != 'admin/games/picturegame/empty.png') {
          displayRevealedCells.add(
            RevealedCell(
              row: row,
              col: col,
              imageId: displayImage.id.toString(),
            ),
          );
        }
      }

      await controller.trackGameProgress(
        GameStageConstant.abort,
        onSuccess: () {
          if (mounted) {
            controller.state = controller.state.copyWith(
              showResult: true,
              isAnswerCorrect: false,
              gameStage: GameStageConstant.abort,
              isLoading: false,
              wrongRow: missingRow,
              wrongCol: missingCol,
              revealedCells: displayRevealedCells,
            );
          }
        },
      );
    }
  }

  List<PicturePosition> _getPicturePositionsLevel3(PicturesGameState state) {
    final pictures = <PicturePosition>[];

    if (state.isInitialStage) {
      // Show allImagesList in initial stage
      final allImagesList = state.gameData?.allImagesList ?? [];
      for (int i = 0; i < allImagesList.length; i++) {
        final row = i ~/ state.columns;
        final col = i % state.columns;
        pictures.add(PicturePosition(
          row: row,
          col: col,
          imageUrl: allImagesList[i].image ?? '',
        ));
      }
    } else if (state.isGameInProgress) {
      // Show displayImagesList in progress stage
      final displayImagesList = state.gameData?.displayImagesList ?? [];
      for (int i = 0; i < displayImagesList.length; i++) {
        final row = i ~/ state.columns;
        final col = i % state.columns;
        final imageUrl = displayImagesList[i].image ?? '';

        // Only add if image exists (skip missing image position)
        if (imageUrl.isNotEmpty) {
          pictures.add(PicturePosition(
            row: row,
            col: col,
            imageUrl: imageUrl,
          ));
        }
      }
    }

    return pictures;
  }

  String _getGameStatusDescription(bool isCorrect) => isCorrect
      ? "Excellent! You completed the game successfully!"
      : "Oops! Wrong answer. Try again!";
}

class Level2TimerWidget extends StatefulWidget {
  final int seconds;

  const Level2TimerWidget({super.key, required this.seconds});

  @override
  State<Level2TimerWidget> createState() => _Level2TimerWidgetState();
}

class _Level2TimerWidgetState extends State<Level2TimerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: 20,
            color: widget.seconds <= 10
                ? Colors.red
                : Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 8),
          Text(
            _formatTime(widget.seconds),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: widget.seconds <= 10 ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

class Level3DialogWithTimer extends StatefulWidget {
  final List<ImageWithId> allImages;
  final Function(int) onImageSelected;
  final int initialSeconds;
  final VoidCallback onTimeout;
  final VoidCallback onCloseDialog;

  const Level3DialogWithTimer({
    super.key,
    required this.allImages,
    required this.onImageSelected,
    required this.onTimeout,
    required this.onCloseDialog,
    this.initialSeconds = 30,
  });

  @override
  State<Level3DialogWithTimer> createState() => _Level3DialogWithTimerState();
}

class _Level3DialogWithTimerState extends State<Level3DialogWithTimer> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _remainingSeconds--;
      });

      if (_remainingSeconds <= 0) {
        timer.cancel();
        if (mounted) {
          widget.onCloseDialog();
          widget.onTimeout();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Column(
        children: [
          textBoldPoppins(
            text: AppLocalizations.of(context).select_image,
            textAlign: TextAlign.center,
            fontSize: 18,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _remainingSeconds <= 10
                  ? Colors.red.withOpacity(0.1)
                  : Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer,
                  size: 18,
                  color: _remainingSeconds <= 10 ? Colors.red : Colors.blue,
                ),
                const SizedBox(width: 6),
                Text(
                  _formatTime(_remainingSeconds),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _remainingSeconds <= 10 ? Colors.red : Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: widget.allImages.length,
          itemBuilder: (context, index) {
            final imageItem = widget.allImages[index];
            final imageUrl = imageItem.image ?? '';
            final imageId = imageItem.id;

            return GestureDetector(
              onTap: () {
                _timer?.cancel();
                if (imageId != null) {
                  widget.onImageSelected(int.parse(imageId.toString()));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: imageUrl.isNotEmpty
                      ? ImageUtil.loadNetworkImage(
                          imageUrl: imageUrl,
                          context: context,
                          sourceId: 1,
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.image,
                            color: Colors.grey[400],
                          ),
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
