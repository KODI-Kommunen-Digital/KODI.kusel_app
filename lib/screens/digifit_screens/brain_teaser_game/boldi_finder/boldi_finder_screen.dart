import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/game_details/details_controller.dart';

import '../../../../common_widgets/common_background_clipper_widget.dart';
import '../../../../common_widgets/common_bottom_nav_card_.dart';
import '../../../../common_widgets/common_html_widget.dart';
import '../../../../common_widgets/device_helper.dart';

import '../../../../common_widgets/digifit/brain_teaser_game/common_component/error_overlay_component.dart';
import '../../../../common_widgets/digifit/brain_teaser_game/common_component/success_overlay_component.dart';
import '../../../../common_widgets/digifit/brain_teaser_game/game_status_card.dart';
import '../../../../common_widgets/digifit/brain_teaser_game/grid_widget.dart';
import '../../../../common_widgets/text_styles.dart';
import '../../../../common_widgets/upstream_wave_clipper.dart';
import '../../../../images_path.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../navigation/navigation.dart';
import '../../digifit_start/digifit_information_controller.dart';
import 'components/arrow_direction.dart';
import 'components/boldi_component.dart';
import 'boldi_finder_controller.dart';
import 'components/pause_icon.dart';
import '../enum/game_session_status.dart';
import 'params/boldi_finder_params.dart';

class BoldiFinderScreen extends ConsumerStatefulWidget {
  final BoldiFinderParams? boldiFinderParams;

  const BoldiFinderScreen({super.key, required this.boldiFinderParams});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BoldiFinderScreenState();
  }
}

class _BoldiFinderScreenState extends ConsumerState<BoldiFinderScreen> {
  CommonGridWidget? _gridGame;
  BoldiOverlayGame? _boldiOverlayGame;
  ArrowOverlayGame? _arrowOverlayGame;
  PauseOverlayGame? _pauseOverlayGame;
  SuccessOverlayGame? _successOverlayGame;
  ErrorOverlayGame? _errorOverlayGame;

  final GlobalKey _gridKey = GlobalKey();
  GlobalKey _boldiKey = GlobalKey();
  GlobalKey _arrowKey = GlobalKey();
  GlobalKey _pauseKey = GlobalKey();

  GlobalKey _successKey = GlobalKey();
  GlobalKey _errorKey = GlobalKey();

  bool? _previousAnswerState;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final controller = ref.read(brainTeaserGameBoldiFinderControllerProvider(
              widget.boldiFinderParams?.levelId ?? 1)
          .notifier);

      controller.onClearOverlays = _clearAllOverlays;

      controller.onArrowUpdate = updateArrow;
      controller.onBoldiUpdate = updateBoldi;

      controller.fetchBrainTeaserGameBoldiFinder(
          gameId: widget.boldiFinderParams?.gameId ?? 1,
          levelId: widget.boldiFinderParams?.levelId ?? 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(brainTeaserGameBoldiFinderControllerProvider(
        widget.boldiFinderParams?.levelId ?? 1));

    if (_previousAnswerState != null && state.isAnswerCorrect == null) {
      if (_successOverlayGame != null) {
        _successOverlayGame?.onRemove();
        _successOverlayGame = null;
      }

      if (_errorOverlayGame != null) {
        _errorOverlayGame?.onRemove();
        _errorOverlayGame = null;
      }

      _successKey = GlobalKey();
      _errorKey = GlobalKey();
    }

    _previousAnswerState = state.isAnswerCorrect;

    final isLoading = state.isLoading;
    final headingText = widget.boldiFinderParams?.title ?? '';

    double gridHeight = 330.w;
    double gridWidth = 330.w;
    int rows = state.boldFinderDataModel?.grid?.row ?? 3;
    int columns = state.boldFinderDataModel?.grid?.col ?? 3;

    bool useInnerPadding = widget.boldiFinderParams?.gameId == 3;

    if (_gridGame == null ||
        _gridGame!.params.rows != rows ||
        _gridGame!.params.columns != columns) {
      _clearAllOverlays();

      _gridGame = CommonGridWidget(
        params: CommonGridParams(
          width: gridWidth,
          height: gridHeight,
          tileHeight: gridHeight / rows,
          tileWidth: gridWidth / columns,
          rows: rows,
          columns: columns,
          borderColor: Theme.of(context).dividerColor,
          useInnerPadding: useInnerPadding,
          onCellTapped: _handleCellTap,
        ),
      );

      _boldiOverlayGame = BoldiOverlayGame(
        row: state.boldiRow,
        column: state.boldiCol,
        gridWidth: gridWidth,
        gridHeight: gridHeight,
        tileWidth: gridWidth / columns,
        tileHeight: gridHeight / rows,
      );

      _arrowOverlayGame = ArrowOverlayGame(
        direction: state.currentArrowDirection ?? 'up',
        gridWidth: gridWidth,
        gridHeight: gridHeight,
        tileWidth: gridWidth / columns,
        tileHeight: gridHeight / rows,
        borderColor: Theme.of(context).dividerColor,
        arrowColor:
            Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
        durationSeconds: state.boldFinderDataModel?.timer ?? 3,
      );

      _pauseOverlayGame = PauseOverlayGame(
        gridWidth: gridWidth,
        gridHeight: gridHeight,
        tileWidth: gridWidth / columns,
        tileHeight: gridHeight / rows,
        borderColor: Theme.of(context).dividerColor,
        arrowColor:
            Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
      );
    }

    _boldiOverlayGame ??= BoldiOverlayGame(
      row: state.boldiRow,
      column: state.boldiCol,
      gridWidth: gridWidth,
      gridHeight: gridHeight,
      tileWidth: gridWidth / columns,
      tileHeight: gridHeight / rows,
    );

    _arrowOverlayGame ??= ArrowOverlayGame(
      direction: state.currentArrowDirection ?? 'up',
      gridWidth: gridWidth,
      gridHeight: gridHeight,
      tileWidth: gridWidth / columns,
      tileHeight: gridHeight / rows,
      borderColor: Theme.of(context).dividerColor,
      arrowColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
      durationSeconds: state.boldFinderDataModel?.timer ?? 3,
    );

    if (state.boldFinderDataModel?.timer != null) {
      _arrowOverlayGame?.updateDuration(state.boldFinderDataModel!.timer!);
    }

    _pauseOverlayGame ??= PauseOverlayGame(
      gridWidth: gridWidth,
      gridHeight: gridHeight,
      tileWidth: gridWidth / columns,
      tileHeight: gridHeight / rows,
      borderColor: Theme.of(context).dividerColor,
      arrowColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
    );

    if (state.isAnswerCorrect == true &&
        state.selectedRow != null &&
        state.selectedCol != null &&
        _successOverlayGame == null) {
      _successOverlayGame = SuccessOverlayGame(
        row: state.selectedRow!,
        column: state.selectedCol!,
        gridWidth: gridWidth,
        gridHeight: gridHeight,
        tileWidth: gridWidth / columns,
        tileHeight: gridHeight / rows,
        successColor: Colors.green,
      );
    }

    if (state.isAnswerCorrect == false &&
        state.selectedRow != null &&
        state.selectedCol != null &&
        _errorOverlayGame == null) {
      final correctRow = state.boldFinderDataModel?.finalPosition?.row ?? 0;
      final correctCol = state.boldFinderDataModel?.finalPosition?.col ?? 0;

      _errorOverlayGame = ErrorOverlayGame(
        wrongRow: state.selectedRow!,
        wrongColumn: state.selectedCol!,
        correctRow: correctRow,
        correctColumn: correctCol,
        gridWidth: gridWidth,
        gridHeight: gridHeight,
        tileWidth: gridWidth / columns,
        tileHeight: gridHeight / rows,
        errorColor: Colors.red,
        correctColor: Colors.green,
      );
    }

    final shouldShowSuccess =
        _successOverlayGame != null && state.isAnswerCorrect == true;

    final shouldShowError =
        _errorOverlayGame != null && state.isAnswerCorrect == false;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop == false) {
          await handleAbortBackNavigation(context);
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
                        child:
                            _buildHeadingArrowSection(headingText: headingText),
                      ),
                      Column(
                        children: [
                          130.verticalSpace,
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: gridHeight,
                              width: gridWidth,
                              child: Stack(
                                children: [
                                  GameWidget(
                                    key: _gridKey,
                                    game: _gridGame!,
                                  ),
                                  Visibility(
                                    visible: state.showBoldi,
                                    child: GameWidget(
                                      key: _boldiKey,
                                      game: _boldiOverlayGame!,
                                    ),
                                  ),
                                  Visibility(
                                    visible: state.showArrow,
                                    child: GameWidget(
                                      key: _arrowKey,
                                      game: _arrowOverlayGame!,
                                    ),
                                  ),
                                  Visibility(
                                    visible: state.showPause,
                                    child: GameWidget(
                                      key: _pauseKey,
                                      game: _pauseOverlayGame!,
                                    ),
                                  ),
                                  if (shouldShowSuccess)
                                    GameWidget(
                                      key: _successKey,
                                      game: _successOverlayGame!,
                                    ),
                                  if (shouldShowError)
                                    GameWidget(
                                      key: _errorKey,
                                      game: _errorOverlayGame!,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          10.verticalSpace,
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 80),
                            child: CommonHtmlWidget(
                              fontSize: 16,
                              data: widget.boldiFinderParams?.desc ?? '',
                            ),
                          ),
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
                    await handleAbortBackNavigation(context);
                  },
                  isFavVisible: false,
                  isFav: false,
                  onGameStageConstantTap: _handleBottomNavTap,
                  gameDetailsStageConstant: state.gameDetailsStageConstant,
                ),
              ),
              if (state.showSuccessDialog || state.showErrorDialog)
                Positioned(
                  bottom: 80.h,
                  left: 0,
                  right: 0,
                  child: GameStatusCardWidget(
                    isStatus: state.isAnswerCorrect ?? false,
                  ),
                ),
            ],
          ),
        ),
      ).loaderDialog(context, isLoading),
    );
  }

  void _clearAllOverlays() {
    _successOverlayGame?.onRemove();
    _successOverlayGame = null;

    _errorOverlayGame?.onRemove();
    _errorOverlayGame = null;

    _boldiOverlayGame?.onRemove();
    _boldiOverlayGame = null;

    _arrowOverlayGame?.onRemove();
    _arrowOverlayGame = null;

    _pauseOverlayGame?.onRemove();
    _pauseOverlayGame = null;

    _successKey = GlobalKey();
    _errorKey = GlobalKey();
    _boldiKey = GlobalKey();
    _arrowKey = GlobalKey();
    _pauseKey = GlobalKey();
  }

  void updateArrow(String direction) {
    _arrowOverlayGame?.updateDirection(direction);
  }

  void updateBoldi(int row, int col) {
    _boldiOverlayGame?.updatePosition(row, col);
  }

  @override
  void dispose() {
    _clearAllOverlays();
    _gridGame = null;
    super.dispose();
  }

  Widget _buildHeadingArrowSection({String? headingText}) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            await handleAbortBackNavigation(context);
          },
          icon: Icon(
              size: DeviceHelper.isMobile(context) ? null : 12.h.w,
              Icons.arrow_back,
              color: Theme.of(context).primaryColor),
        ),
        2.horizontalSpace,
        textSemiBoldPoppins(
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: Theme.of(context).textTheme.bodyLarge?.color,
          text: headingText ?? '',
        ),
      ],
    );
  }

  Future<void> _handleBottomNavTap() async {
    final controller = ref.read(brainTeaserGameBoldiFinderControllerProvider(
            widget.boldiFinderParams?.levelId ?? 1)
        .notifier);

    final stage = ref
        .read(brainTeaserGameBoldiFinderControllerProvider(
            widget.boldiFinderParams?.levelId ?? 1))
        .gameDetailsStageConstant;

    switch (stage) {
      case GameStageConstant.initial:
        await controller.startGameSequence();
        break;

      case GameStageConstant.progress:
        await handleAbortBackNavigation(context);
        break;

      case GameStageConstant.abort:
        _clearOverlaysOnly();

        final levelId = widget.boldiFinderParams?.levelId ?? 1;

        await controller.restartGame(
            widget.boldiFinderParams?.gameId ?? 1, levelId);
        break;

      case GameStageConstant.complete:
        handleAbortBackNavigation(context);
        break;

      default:
        break;
    }
  }

  void _clearOverlaysOnly() {
    _successOverlayGame?.onRemove();
    _successOverlayGame = null;

    _errorOverlayGame?.onRemove();
    _errorOverlayGame = null;

    _successKey = GlobalKey();
    _errorKey = GlobalKey();
  }

  void _handleCellTap(int row, int column) {
    ref
        .read(brainTeaserGameBoldiFinderControllerProvider(
                widget.boldiFinderParams?.levelId ?? 1)
            .notifier)
        .checkAnswer(row, column, () {
      final isCorrect = ref
              .read(brainTeaserGameBoldiFinderControllerProvider(
                  widget.boldiFinderParams?.levelId ?? 1))
              .isAnswerCorrect ??
          false;

      GameStatusCardWidget(isStatus: isCorrect);
    });
  }

  Future<void> handleAbortBackNavigation(BuildContext context) async {
    final controller = ref.read(brainTeaserGameBoldiFinderControllerProvider(
            widget.boldiFinderParams?.levelId ?? 1)
        .notifier);

    final state = ref.read(brainTeaserGameBoldiFinderControllerProvider(
        widget.boldiFinderParams?.levelId ?? 1));

    GameStageConstant currentGameState = state.gameDetailsStageConstant;

    if (currentGameState == GameStageConstant.progress) {
      controller.pauseSequence();
      showAbortedDialog(context, AppLocalizations.of(context).abort_game,
          AppLocalizations.of(context).abort_game_desc);
    } else if (currentGameState == GameStageConstant.complete) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: textBoldPoppins(
              text: AppLocalizations.of(context).level_complete,
              textAlign: TextAlign.center,
              fontSize: 16),
          content: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: textRegularPoppins(
                text: AppLocalizations.of(context).level_complete_desc,
                textAlign: TextAlign.center,
                textOverflow: TextOverflow.visible,
                fontSize: 12),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () async {
                ref.read(navigationProvider).removeDialog(context: context);

                ref.read(navigationProvider).removeTopPage(context: context);

               await ref
                    .read(brainTeaserGameDetailsControllerProvider(
                            widget.boldiFinderParams?.gameId ?? 1)
                        .notifier)
                    .fetchBrainTeaserGameDetails(
                        gameId: widget.boldiFinderParams?.gameId ?? 1);
                await ref
                   .read(digifitInformationControllerProvider.notifier)
                   .fetchDigifitInformation();
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
    } else {
      ref.read(navigationProvider).removeTopPage(context: context);
    }
  }

  void showAbortedDialog(
      BuildContext context, String title, String description) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: textBoldPoppins(
            text: title, textAlign: TextAlign.center, fontSize: 16),
        content: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: textRegularPoppins(
              text: description,
              textAlign: TextAlign.center,
              textOverflow: TextOverflow.visible,
              fontSize: 12),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              ref
                  .read(brainTeaserGameBoldiFinderControllerProvider(
                          widget.boldiFinderParams?.levelId ?? 1)
                      .notifier)
                  .resumeSequence();

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
              await ref.read(navigationProvider).removeDialog(context: context);

              final sessionId = ref
                      .read(brainTeaserGameBoldiFinderControllerProvider(
                          widget.boldiFinderParams?.levelId ?? 1))
                      .boldFinderDataModel
                      ?.sessionId ??
                  1;

              await ref
                  .read(brainTeaserGameBoldiFinderControllerProvider(
                          widget.boldiFinderParams?.levelId ?? 1)
                      .notifier)
                  .trackGameDetails(sessionId, GameStageConstant.abort, () {
                ref.read(navigationProvider).removeTopPage(context: context);
              });
            },
            isDefaultAction: true,
            child: textBoldPoppins(
                text: AppLocalizations.of(context).digifit_abort,
                textOverflow: TextOverflow.visible,
                fontSize: 14),
          ),
        ],
      ),
    );
  }
}
